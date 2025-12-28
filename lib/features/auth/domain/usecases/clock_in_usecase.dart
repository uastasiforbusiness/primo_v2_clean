import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../entities/shift_entity.dart';
import '../repositories/auth_repository.dart';

class ClockInUseCase {
  final AuthRepository repository;

  ClockInUseCase(this.repository);

  Future<Either<Failure, ShiftEntity>> call({
    required String employeeId,
    required double initialCashAmount,
  }) async {
    // Validate initial cash
    if (initialCashAmount < 0) {
      return const Left(
        ValidationFailure(message: 'Initial cash cannot be negative'),
      );
    }

    // Check if employee already has an active shift
    final activeShiftResult = await repository.getActiveShift(employeeId);
    
    return activeShiftResult.fold(
      Left.new,
      (activeShift) {
        if (activeShift != null) {
          return const Left(
            ValidationFailure(message: 'Employee already has an active shift'),
          );
        }

        final initialCash = Money.fromDouble(initialCashAmount);
        return repository.clockIn(
          employeeId: employeeId,
          initialCash: initialCash,
        );
      },
    );
  }
}
