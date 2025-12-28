import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../repositories/auth_repository.dart';

class ClockOutUseCase {
  final AuthRepository repository;

  ClockOutUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String shiftId,
    required double finalCashAmount,
  }) async {
    // Validate final cash
    if (finalCashAmount < 0) {
      return const Left(
        ValidationFailure(message: 'Final cash cannot be negative'),
      );
    }

    // Check if there's an active break
    final hasActiveBreakResult = await repository.hasActiveBreak(shiftId);
    
    return hasActiveBreakResult.fold(
      Left.new,
      (hasBreak) {
        if (hasBreak) {
          return const Left(
            ValidationFailure(message: 'Cannot clock out with an active break'),
          );
        }

        final finalCash = Money.fromDouble(finalCashAmount);
        return repository.clockOut(
          shiftId: shiftId,
          finalCash: finalCash,
        );
      },
    );
  }
}
