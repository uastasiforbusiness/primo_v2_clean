import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/employee_repository.dart';

/// Soft deletes an employee by setting isActive = false
///
/// Business rules:
/// - Employee must exist
/// - Cannot delete the admin user (admin-001)
/// - Wrapped in ACID transaction with audit log
class DeleteEmployeeUseCase {
  final EmployeeRepository repository;

  DeleteEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call(String employeeId) async {
    // Prevent deleting admin user
    if (employeeId == 'admin-001') {
      return const Left(ValidationFailure(message: 'Cannot delete admin user'));
    }

    return await repository.deleteEmployee(employeeId);
  }
}
