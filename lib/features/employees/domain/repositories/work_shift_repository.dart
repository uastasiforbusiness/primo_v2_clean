import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/work_shift_entity.dart';

abstract class WorkShiftRepository {
  Future<Either<Failure, WorkShiftEntity>> clockIn(String employeeId);
  Future<Either<Failure, WorkShiftEntity>> clockOut(String employeeId);
  Future<Either<Failure, WorkShiftEntity?>> getActiveWorkShift(String employeeId);
  Future<Either<Failure, List<WorkShiftEntity>>> getWorkShifts(String employeeId);
}
