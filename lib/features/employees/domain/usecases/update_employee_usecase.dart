import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../../../../core/error/failures.dart';
import '../repositories/employee_repository.dart';

class UpdateEmployeeUseCase {
  final EmployeeRepository repository;
  UpdateEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(EmployeeEntity employee, {String? newPin, required String actorId}) async {
    return await repository.updateEmployee(employee, newPin: newPin, actorId: actorId);
  }
}
