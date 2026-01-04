import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;
  CreateEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(EmployeeEntity employee, String pin, {required String actorId}) async {
    return await repository.createEmployee(employee, pin, actorId: actorId);
  }
}
