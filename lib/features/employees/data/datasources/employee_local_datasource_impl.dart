import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import '../../../../core/error/exceptions.dart';
import '../../../../infrastructure/database/app_database.dart';
import 'employee_local_datasource.dart';

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;

  EmployeeLocalDataSourceImpl(this.database, this.uuid);

  @override
  Future<List<Employee>> getEmployees() async {
    return await database.getActiveEmployees();
  }

  @override
  Future<void> createEmployee(Employee employee) async {
    try {
      await database.transaction(() async {
        // 1. Validar unicidad de PIN
        final isPinUnique = await database.isPinUnique(employee.pinHash);
        if (!isPinUnique) {
          throw DuplicateException('PIN already exists');
        }

        // 2. Insertar empleado
        await database.insertEmployee(
          EmployeesCompanion.insert(
            id: employee.id,
            name: employee.name,
            lastName: employee.lastName,
            emergencyPhone: employee.emergencyPhone,
            role: employee.role,
            pinHash: employee.pinHash,
            pinSalt: Value(employee.pinSalt),
            pinBlindIndex: Value(employee.pinBlindIndex),
            securityVersion: Value(employee.securityVersion),
            email: Value(employee.email),
            phone: Value(employee.phone),
          ),
        );

        // 3. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'employee_created',
            employeeId: Value(employee.id),
            metadata: Value(jsonEncode({'role': employee.role})),
          ),
        );
      });
    } catch (e) {
      if (e is DuplicateException) rethrow;
      throw DatabaseException('Create employee failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmployee(
    Employee employee, {
    String? newPinHash,
    String? newPinSalt,
    String? newPinBlindIndex,
    int? newSecurityVersion,
  }) async {
    try {
      await database.transaction(() async {
        // 1. Si hay nuevo PIN, validar unicidad (excluyendo el empleado actual)
        if (newPinBlindIndex != null) {
          final isPinUnique = await database.isPinUnique(
            newPinBlindIndex,
            excludeEmployeeId: employee.id,
          );
          if (!isPinUnique) {
            throw DuplicateException('PIN already exists');
          }
        }

        // 2. Actualizar empleado (usando el nuevo método de update parcial)
        final companion = EmployeesCompanion(
          id: Value(employee.id),
          name: Value(employee.name),
          lastName: Value(employee.lastName),
          email: Value(employee.email),
          phone: Value(employee.phone),
          emergencyPhone: Value(employee.emergencyPhone),
          role: Value(employee.role),
          pinHash: newPinHash != null ? Value(newPinHash) : Value(employee.pinHash),
          pinSalt: newPinSalt != null ? Value(newPinSalt) : Value(employee.pinSalt),
          pinBlindIndex:
              newPinBlindIndex != null ? Value(newPinBlindIndex) : Value(employee.pinBlindIndex),
          securityVersion: newSecurityVersion != null
              ? Value(newSecurityVersion)
              : Value(employee.securityVersion),
          isActive: Value(employee.isActive),
          updatedAt: Value(DateTime.now()),
        );

        await database.updateEmployee(companion);

        // 3. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'employee_updated',
            employeeId: Value(employee.id),
            metadata: Value(jsonEncode({
              'role': employee.role,
              'pinChanged': newPinHash != null,
            })),
          ),
        );
      });
    } catch (e) {
      if (e is DuplicateException) rethrow;
      throw DatabaseException('Update employee failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteEmployee(String employeeId) async {
    try {
      await database.transaction(() async {
        // 1. Soft delete (isActive = false)
        await database.softDeleteEmployee(employeeId);

        // 2. Registrar auditoría
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'employee_deleted',
            employeeId: Value(employeeId),
            metadata: Value(jsonEncode({'deleteType': 'soft'})),
          ),
        );
      });
    } catch (e) {
      throw DatabaseException('Delete employee failed: ${e.toString()}');
    }
  }

  @override
  Future<WorkShift> clockIn(String employeeId, double? hourlyRate) async {
    try {
      return await database.transaction(() async {
        // 1. Verify if there is already an active shift
        final activeShift = await database.getActiveWorkShiftByEmployeeId(employeeId);
        if (activeShift != null) {
          throw DuplicateException('Employee already clocked in');
        }

        final id = uuid.v4();
        final shift = WorkShiftsCompanion.insert(
          id: id,
          employeeId: employeeId,
          hourlyRateSnapshot: Value(hourlyRate),
          clockIn: Value(DateTime.now()),
        );

        await database.insertWorkShift(shift);

        // 2. Log Audit Event
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'clock_in',
            employeeId: Value(employeeId),
            metadata: Value(jsonEncode({'hourlyRate': hourlyRate ?? 0})),
          ),
        );

        // Return the created shift (fetch it to be sure)
        final createdShift =
            await (database.select(database.workShifts)..where((s) => s.id.equals(id))).getSingle();
        return createdShift;
      });
    } catch (e) {
      if (e is DuplicateException) rethrow;
      throw DatabaseException('Clock-in failed: ${e.toString()}');
    }
  }

  @override
  Future<WorkShift> clockOut(String employeeId) async {
    try {
      return await database.transaction(() async {
        final activeShift = await database.getActiveWorkShiftByEmployeeId(employeeId);
        if (activeShift == null) {
          throw DatabaseException('No active shift found to clock out');
        }

        await database.closeWorkShift(activeShift.id);

        // 2. Log Audit Event
        await database.insertAuditEvent(
          AuditEventsCompanion.insert(
            id: uuid.v4(),
            eventType: 'clock_out',
            employeeId: Value(employeeId),
            metadata: Value(jsonEncode({
              'shiftDurationMinutes': DateTime.now().difference(activeShift.clockIn).inMinutes,
            })),
          ),
        );

        // Return updated shift
        final updatedShift = await (database.select(database.workShifts)
              ..where((s) => s.id.equals(activeShift.id)))
            .getSingle();
        return updatedShift;
      });
    } catch (e) {
      throw DatabaseException('Clock-out failed: ${e.toString()}');
    }
  }

  @override
  Future<WorkShift?> getActiveWorkShift(String employeeId) async {
    return await database.getActiveWorkShiftByEmployeeId(employeeId);
  }

  @override
  Future<List<WorkShift>> getWorkShifts(String employeeId) async {
    return await database.getWorkShiftsByEmployeeId(employeeId);
  }
}
