import '../../../../infrastructure/database/app_database.dart';

abstract class EmployeeLocalDataSource {
  Future<List<Employee>> getEmployees();
  Future<void> createEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee, {String? newPinHash});
  Future<void> deleteEmployee(String employeeId);
}
