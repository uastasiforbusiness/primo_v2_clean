import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/shift_repository.dart';

class StartBreakUseCase {
  final ShiftRepository repository;

  StartBreakUseCase(this.repository);

  Future<Either<Failure, void>> call(String shiftId) async {
    // Validación: verificar que no hay break activo
    final hasBreakResult = await repository.hasActiveBreak(shiftId);

    return hasBreakResult.fold(
      Left.new,
      (hasBreak) {
        if (hasBreak) {
          return const Left(
            ValidationFailure(message: 'Break already active'),
          );
        }

        return repository.startBreak(shiftId);
      },
    );
  }
}
