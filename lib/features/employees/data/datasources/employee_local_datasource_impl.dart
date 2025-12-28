import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/exceptions.dart';
import '../../../database/data/app_database.dart';
import 'employee_local_datasource.dart';

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final AppDatabase database;
  final Uuid uuid;

  EmployeeLocalDataSourceImpl(this.database, this.uuid);

  @override
  Future<List<Employee>> getEmployees() async {
    return await database.getAllEmployees();
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
            email: Value(employee.email),
            phone: Value(employee.phone),
          ),
        );

        // 3. Registrar auditoría (si falla, rollback automático)
        // TODO: Descomentar cuando se implemente el módulo de auditoría
        // await database.insertAuditEvent(
        //   AuditEventsCompanion.insert(
        //     id: uuid.v4(),
        //     eventType: 'employee_created',
        //     employeeId: Value(employee.id),
        //     metadata: Value('Role: ${employee.role}'),
        //   ),
        // );
      });
    } catch (e) {
      if (e is DuplicateException) rethrow;
      throw DatabaseException('Create employee failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateEmployee(Employee employee, {String? newPinHash}) async {
    try {
      await database.transaction(() async {
        // 1. Si hay nuevo PIN, validar unicidad (excluyendo el empleado actual)
        if (newPinHash != null) {
          final isPinUnique = await database.isPinUnique(
            newPinHash,
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
          isActive: Value(employee.isActive),
          updatedAt: Value(DateTime.now()),
        );

        await database.updateEmployee(companion);

        // 3. Registrar auditoría (si falla, rollback automático)
        // TODO: Descomentar cuando se implemente el módulo de auditoría
        // await database.insertAuditEvent(
        //   AuditEventsCompanion.insert(
        //     id: uuid.v4(),
        //     eventType: 'employee_updated',
        //     employeeId: Value(employee.id),
        //     metadata: Value('Role: ${employee.role}, PIN changed: ${newPinHash != null}'),
        //   ),
        // );
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

        // 2. Registrar auditoría (si falla, rollback automático)
        // TODO: Descomentar cuando se implemente el módulo de auditoría
        // await database.insertAuditEvent(
        //   AuditEventsCompanion.insert(
        //     id: uuid.v4(),
        //     eventType: 'employee_deleted',
        //     employeeId: Value(employeeId),
        //     metadata: const Value('Soft delete'),
        //   ),
        // );
      });
    } catch (e) {
      throw DatabaseException('Delete employee failed: ${e.toString()}');
    }
  }
}
