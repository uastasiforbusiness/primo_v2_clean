import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_shift_entity.dart';
import '../../domain/repositories/work_shift_repository.dart';

class LaborClockOutUseCase {
  final WorkShiftRepository repository;

  LaborClockOutUseCase(this.repository);

  Future<Either<Failure, WorkShiftEntity>> call(LaborClockOutParams params) async {
    return await repository.clockOut(params.employeeId);
  }
}

class LaborClockOutParams extends Equatable {
  final String employeeId;

  const LaborClockOutParams({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];
}
