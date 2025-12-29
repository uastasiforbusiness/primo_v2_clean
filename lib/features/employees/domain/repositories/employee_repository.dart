import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees();
  Future<Either<Failure, void>> createEmployee(EmployeeEntity employee, String pin);
  Future<Either<Failure, void>> updateEmployee(EmployeeEntity employee, {String? newPin});
  Future<Either<Failure, void>> deleteEmployee(String employeeId);
}
