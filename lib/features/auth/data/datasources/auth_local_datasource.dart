import 'package:drift/drift.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../database/data/app_database.dart';
import 'package:uuid/uuid.dart';

abstract class AuthLocalDataSource {
  Future<Employee> loginWithPin(String pin);
  Future<Shift> clockIn({
    required String employeeId,
    required double initialCash,
  });
  Future<void> clockOut({
    required String shiftId,
    required double finalCash,
  });
  Future<Shift?> getActiveShift(String employeeId);
  Future<void> startBreak(String shiftId);
  Future<void> endBreak(String shiftId);
  Future<bool> hasActiveBreak(String shiftId);
  Future<void> logAuditEvent({
    required String eventType,
    String? employeeId,
    String? metadata,
  });
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;

  AuthLocalDataSourceImpl({
    required this.database,
    required this.uuid,
  });

  @override
  Future<Employee> loginWithPin(String pin) async {
    try {
      final pinHash = Pin.fromPlainText(pin).toHash();
      final employee = await database.getEmployeeByPinHash(pinHash);

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
  Future<Shift> clockIn({
    required String employeeId,
    required double initialCash,
  }) async {
    try {
      final shiftId = uuid.v4();
      
      await database.insertShift(
        ShiftsCompanion.insert(
          id: shiftId,
          employeeId: employeeId,
          cashRegisterId: 'default-register',
          initialCash: initialCash,
        ),
      );

      await logAuditEvent(
        eventType: 'clock_in',
        employeeId: employeeId,
        metadata: 'Initial cash: \$$initialCash',
      );

      final shift = await database.getActiveShiftByEmployeeId(employeeId);
      if (shift == null) {
        throw DatabaseException('Failed to retrieve created shift');
      }

      return shift;
    } catch (e) {
      throw DatabaseException('Clock-in failed: ${e.toString()}');
    }
  }

  @override
  Future<void> clockOut({
    required String shiftId,
    required double finalCash,
  }) async {
    try {
      await database.closeShift(shiftId, finalCash);

      await logAuditEvent(
        eventType: 'clock_out',
        metadata: 'Shift ID: $shiftId, Final cash: \$$finalCash',
      );
    } catch (e) {
      throw DatabaseException('Clock-out failed: ${e.toString()}');
    }
  }

  @override
  Future<Shift?> getActiveShift(String employeeId) async {
    try {
      return await database.getActiveShiftByEmployeeId(employeeId);
    } catch (e) {
      throw DatabaseException('Failed to get active shift: ${e.toString()}');
    }
  }

  @override
  Future<void> startBreak(String shiftId) async {
    try {
      final breakId = uuid.v4();
      
      await database.insertBreak(
        BreaksCompanion.insert(
          id: breakId,
          shiftId: shiftId,
        ),
      );

      await logAuditEvent(
        eventType: 'break_start',
        metadata: 'Shift ID: $shiftId',
      );
    } catch (e) {
      throw DatabaseException('Start break failed: ${e.toString()}');
    }
  }

  @override
  Future<void> endBreak(String shiftId) async {
    try {
      final activeBreak = await database.getActiveBreakByShiftId(shiftId);
      
      if (activeBreak == null) {
        throw ValidationException('No active break found');
      }

      await database.endBreak(activeBreak.id);

      await logAuditEvent(
        eventType: 'break_end',
        metadata: 'Shift ID: $shiftId',
      );
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('End break failed: ${e.toString()}');
    }
  }

  @override
  Future<bool> hasActiveBreak(String shiftId) async {
    try {
      final activeBreak = await database.getActiveBreakByShiftId(shiftId);
      return activeBreak != null;
    } catch (e) {
      throw DatabaseException('Check active break failed: ${e.toString()}');
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
      print('Audit event failed: ${e.toString()}');
    }
  }
}
