import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class GetEmployeesUseCase {
  final EmployeeRepository repository;

  GetEmployeesUseCase(this.repository);

  Future<Either<Failure, List<EmployeeEntity>>> call() async {
    return await repository.getEmployees();
  }
}
