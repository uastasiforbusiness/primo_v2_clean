import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../repositories/shift_repository.dart';

class ClockOutUseCase {
  final ShiftRepository repository;

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
    final activeBreakResult = await repository.getActiveBreakStartTime(shiftId);

    return activeBreakResult.fold(
      Left.new,
      (startTime) {
        if (startTime != null) {
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
