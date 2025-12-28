import '../../../database/data/app_database.dart';

abstract class EmployeeLocalDataSource {
  Future<List<Employee>> getEmployees();
  Future<void> createEmployee(Employee employee);
  Future<void> updateEmployee(Employee employee);
}
