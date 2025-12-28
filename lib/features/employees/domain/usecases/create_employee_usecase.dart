import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

class CreateEmployeeUseCase {
  final EmployeeRepository repository;

  CreateEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(EmployeeEntity employee, String pin) async {
    return await repository.createEmployee(employee, pin);
  }
}
