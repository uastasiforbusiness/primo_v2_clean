import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../../../../core/error/failures.dart';

abstract class EmployeeRepository {
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees();
  Future<Either<Failure, void>> createEmployee(EmployeeEntity employee, String pin, {required String actorId});
  Future<Either<Failure, void>> updateEmployee(EmployeeEntity employee, {String? newPin, required String actorId});
  Future<Either<Failure, void>> deleteEmployee(String employeeId, {required String actorId});
}
