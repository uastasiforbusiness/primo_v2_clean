import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/employee_repository.dart';

class DeleteEmployeeUseCase {
  final EmployeeRepository repository;
  DeleteEmployeeUseCase(this.repository);

  Future<Either<Failure, void>> call({required String employeeId, required String actorId}) async {
    if (employeeId == 'admin-001') {
      return const Left(ValidationFailure(message: 'Cannot delete admin user'));
    }
    return await repository.deleteEmployee(employeeId, actorId: actorId);
  }
}
