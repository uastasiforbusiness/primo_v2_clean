import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_shift_entity.dart';
import '../../domain/repositories/work_shift_repository.dart';

class LaborClockInUseCase {
  final WorkShiftRepository repository;

  LaborClockInUseCase(this.repository);

  Future<Either<Failure, WorkShiftEntity>> call(LaborClockInParams params) async {
    return await repository.clockIn(params.employeeId);
  }
}

class LaborClockInParams extends Equatable {
  final String employeeId;

  const LaborClockInParams({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];
}
