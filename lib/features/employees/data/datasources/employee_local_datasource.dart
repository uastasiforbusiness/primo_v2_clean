import '../../../../infrastructure/database/app_database.dart';

abstract class EmployeeLocalDataSource {
  Future<List<Employee>> getEmployees();
  Future<void> createEmployee(Employee employee, {required String performedBy});
  Future<void> updateEmployee(
    Employee employee, {
    required String performedBy,
    String? newPinHash,
    String? newPinSalt,
    String? newPinBlindIndex,
    int? newSecurityVersion,
  });
  Future<void> deleteEmployee(String employeeId, {required String performedBy});

  // Work Shifts
  Future<WorkShift> clockIn(String employeeId, double? hourlyRate);
  Future<WorkShift> clockOut(String employeeId);
  Future<WorkShift?> getActiveWorkShift(String employeeId);
  Future<List<WorkShift>> getWorkShifts(String employeeId);
}
