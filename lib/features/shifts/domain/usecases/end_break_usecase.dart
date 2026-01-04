import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/shift_repository.dart';

class EndBreakUseCase {
  final ShiftRepository repository;

  EndBreakUseCase(this.repository);

  Future<Either<Failure, void>> call(String shiftId) async {
    // Validación: debe haber break activo
    final activeBreakResult = await repository.getActiveBreakStartTime(shiftId);

    return activeBreakResult.fold(
      Left.new,
      (startTime) {
        if (startTime == null) {
          return const Left(
            ValidationFailure(message: 'No active break found'),
          );
        }

        return repository.endBreak(shiftId);
      },
    );
  }
}
