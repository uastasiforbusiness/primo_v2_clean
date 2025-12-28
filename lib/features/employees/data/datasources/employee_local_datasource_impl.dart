import 'package:drift/drift.dart';
import '../../../database/data/app_database.dart';
import 'employee_local_datasource.dart';

class EmployeeLocalDataSourceImpl implements EmployeeLocalDataSource {
  final AppDatabase database;

  EmployeeLocalDataSourceImpl(this.database);

  @override
  Future<List<Employee>> getEmployees() async {
    return await database.getAllEmployees();
  }

  @override
  Future<void> createEmployee(Employee employee) async {
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
  }

  @override
  Future<void> updateEmployee(Employee employee) async {
    // Implementación futura
  }
}
