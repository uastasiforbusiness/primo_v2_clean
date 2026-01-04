import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/security/security_service.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../../infrastructure/database/app_database.dart';

abstract class AuthLocalDataSource {
  Future<Employee> loginWithPin(String pin);
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;
  final SecurityService securityService;
  final Uuid uuid;
  final Logger logger = Logger();

  AuthLocalDataSourceImpl({
    required this.database,
    required this.securityService,
    required this.uuid,
  });

  @override
  Future<Employee> loginWithPin(String pin) async {
    try {
      logger.d('Login attempt initiated');

      final pepper = await securityService.getMasterPepper();
      final pinObj = Pin.fromPlainText(pin);
      final blindIndex = await pinObj.toBlindIndex(pepper);

      final Employee? matchedEmployee = await database.getEmployeeByBlindIndex(blindIndex);

      logger.d('Employee lookup result: ${matchedEmployee != null ? 'found' : 'not found'}');

      if (matchedEmployee == null) {
        await logAuditEvent(
          eventType: 'login_failed',
          metadata: {'reason': 'Invalid PIN attempt'},
        );
        throw AuthException('Invalid PIN');
      }

      if (!matchedEmployee.isActive) {
        await logAuditEvent(
          eventType: 'login_failed',
          employeeId: matchedEmployee.id,
          metadata: {'reason': 'Inactive employee'},
        );
        throw AuthException('Employee is inactive');
      }

      // Verificación ADICIONAL (Defensa en Profundidad)
      // Aunque el Blind Index coincide, verificamos contra el hash salteado completo
      final salt = matchedEmployee.pinSalt;
      if (salt == null) {
        logger.e('Crucial data missing: pinSalt for employee ${matchedEmployee.id}');
        throw AuthException('Security integrity failure');
      }

      final verifiedHash = await pinObj.toHashWithSalt(salt, pepper);
      if (verifiedHash != matchedEmployee.pinHash) {
        logger.w(
          'CRITICAL: Blind Index matched but hash verification failed for ${matchedEmployee.id}',
        );
        throw AuthException('Invalid PIN');
      }

      await logAuditEvent(
        eventType: 'login_success',
        employeeId: matchedEmployee.id,
      );

      return matchedEmployee;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw DatabaseException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // Convertir el Map a JSON string antes de guardarlo
      String? jsonMetadata;
      if (metadata != null) {
        jsonMetadata = jsonEncode(metadata);
      }

      await database.insertAuditEvent(
        AuditEventsCompanion.insert(
          id: uuid.v4(),
          eventType: eventType,
          employeeId: Value(employeeId),
          metadata: Value(jsonMetadata),
        ),
      );
    } catch (e) {
      // Don't throw on audit failures to avoid breaking main operations
      logger.e('Audit event failed: ${e.toString()}');
    }
  }
}
