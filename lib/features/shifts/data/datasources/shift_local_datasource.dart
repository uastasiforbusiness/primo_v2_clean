import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../infrastructure/database/app_database.dart';

abstract class ShiftLocalDataSource {
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
}

class ShiftLocalDataSourceImpl implements ShiftLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;
  final Logger logger = Logger();

  ShiftLocalDataSourceImpl({
    required this.database,
    required this.uuid,
  });

  @override
  Future<Shift> clockIn({
    required String employeeId,
    required double initialCash,
  }) async {
    try {
      return await database.transaction(() async {
        final shiftId = uuid.v4();

        // 1. Insertar shift
        await database.insertShift(
          ShiftsCompanion.insert(
            id: shiftId,
            employeeId: employeeId,
            cashRegisterId: 'default-register',
            initialCash: initialCash,
          ),
        );

        // 2. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'shift_clock_in',
            employeeId: Value(employeeId),
            metadata: Value('Initial cash: \$$initialCash'),
          ),
        );

        // 3. Recuperar shift creado
        final shift = await database.getActiveShiftByEmployeeId(employeeId);
        if (shift == null) {
          throw DatabaseException('Failed to retrieve created shift');
        }

        return shift;
      });
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
      await database.transaction(() async {
        // 1. Verificar que no hay break activo
        final activeBreak = await database.getActiveBreakByShiftId(shiftId);
        if (activeBreak != null) {
          throw ValidationException('Cannot clock out with active break');
        }

        // 2. Cerrar shift
        await database.closeShift(shiftId, finalCash);

        // 3. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'shift_clock_out',
            metadata: Value('Shift ID: $shiftId, Final cash: \$$finalCash'),
          ),
        );
      });
    } catch (e) {
      if (e is ValidationException) rethrow;
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
      await database.transaction(() async {
        // 1. Verificar que shift está activo
        final shift = await database.getShiftById(shiftId);
        if (shift == null || shift.endedAt != null) {
          throw ValidationException('Shift not found or already closed');
        }

        // 2. Verificar que no hay break activo
        final activeBreak = await database.getActiveBreakByShiftId(shiftId);
        if (activeBreak != null) {
          throw ValidationException('Break already active');
        }

        // 3. Insertar break
        final breakId = uuid.v4();
        await database.insertBreak(
          BreaksCompanion.insert(
            id: breakId,
            shiftId: shiftId,
          ),
        );

        // 4. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'break_start',
            metadata: Value('Shift ID: $shiftId'),
          ),
        );
      });
    } catch (e) {
      if (e is ValidationException) rethrow;
      throw DatabaseException('Start break failed: ${e.toString()}');
    }
  }

  @override
  Future<void> endBreak(String shiftId) async {
    try {
      await database.transaction(() async {
        // 1. Obtener break activo
        final activeBreak = await database.getActiveBreakByShiftId(shiftId);

        // 2. Validar que existe
        if (activeBreak == null) {
          throw ValidationException('No active break found');
        }

        // 3. Cerrar break
        await database.endBreak(activeBreak.id);

        // 4. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'break_end',
            metadata: Value('Shift ID: $shiftId'),
          ),
        );
      });
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
}
