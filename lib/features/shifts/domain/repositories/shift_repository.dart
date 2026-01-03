import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../entities/shift_entity.dart';

abstract class ShiftRepository {
  Future<Either<Failure, ShiftEntity>> clockIn({
    required String employeeId,
    required Money initialCash,
  });

  Future<Either<Failure, void>> clockOut({
    required String shiftId,
    required Money finalCash,
  });

  Future<Either<Failure, ShiftEntity?>> getActiveShift(String employeeId);

  Future<Either<Failure, void>> startBreak(String shiftId);

  Future<Either<Failure, void>> endBreak(String shiftId);

  Future<Either<Failure, bool>> hasActiveBreak(String shiftId);
}
