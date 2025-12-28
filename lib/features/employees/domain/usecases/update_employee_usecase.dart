import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/employee_entity.dart';
import '../repositories/employee_repository.dart';

/// Updates an existing employee's information
///
/// Business rules:
/// - Employee must exist
/// - If PIN is changed, it must be unique
/// - Wrapped in ACID transaction
class UpdateEmployeeUseCase {
  final EmployeeRepository repository;

  UpdateEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(EmployeeEntity employee, {String? newPin}) async {
    return await repository.updateEmployee(employee, newPin: newPin);
  }
}
