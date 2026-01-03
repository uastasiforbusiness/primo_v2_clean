import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/shift_repository.dart';

class EndBreakUseCase {
  final ShiftRepository repository;

  EndBreakUseCase(this.repository);

  Future<Either<Failure, void>> call(String shiftId) async {
    // Validación: debe haber break activo
    final hasBreakResult = await repository.hasActiveBreak(shiftId);

    return hasBreakResult.fold(
      Left.new,
      (hasBreak) {
        if (!hasBreak) {
          return const Left(
            ValidationFailure(message: 'No active break found'),
          );
        }

        return repository.endBreak(shiftId);
      },
    );
  }
}
