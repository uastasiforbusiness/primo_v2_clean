import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../database/data/app_database.dart';

abstract class AuthLocalDataSource {
  Future<Employee> loginWithPin(String pin);
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;
  final Logger logger = Logger();

  AuthLocalDataSourceImpl({
    required this.database,
    required this.uuid,
  });

  @override
  Future<Employee> loginWithPin(String pin) async {
    try {
      logger.d('🔐 Login attempt with PIN: $pin');
      final pinHash = Pin.fromPlainText(pin).toHash();
      logger.d('🔑 Generated hash: $pinHash');

      final employee = await database.getEmployeeByPinHash(pinHash);
      logger.d('👤 Employee found: ${employee != null ? employee.id : 'null'}');

      if (employee == null) {
        await logAuditEvent(
          eventType: 'login_failed',
          metadata: 'Invalid PIN attempt',
        );
        throw AuthException('Invalid PIN');
      }

      if (!employee.isActive) {
        await logAuditEvent(
          eventType: 'login_failed',
          employeeId: employee.id,
          metadata: 'Inactive employee',
        );
        throw AuthException('Employee is inactive');
      }

      await logAuditEvent(
        eventType: 'login_success',
        employeeId: employee.id,
      );

      return employee;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw DatabaseException('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  }) async {
    try {
      await database.insertAuditEvent(
        AuditEventsCompanion.insert(
          id: uuid.v4(),
          eventType: eventType,
          employeeId: Value(employeeId),
          metadata: Value(metadata),
        ),
      );
    } catch (e) {
      // Don't throw on audit failures to avoid breaking main operations
      logger.e('Audit event failed: ${e.toString()}');
    }
  }
}
