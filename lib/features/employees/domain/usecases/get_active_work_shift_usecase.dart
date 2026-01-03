import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_shift_entity.dart';
import '../../domain/repositories/work_shift_repository.dart';

class GetActiveWorkShiftUseCase {
  final WorkShiftRepository repository;

  GetActiveWorkShiftUseCase(this.repository);

  Future<Either<Failure, WorkShiftEntity?>> call(GetActiveWorkShiftParams params) async {
    return await repository.getActiveWorkShift(params.employeeId);
  }
}

class GetActiveWorkShiftParams extends Equatable {
  final String employeeId;

  const GetActiveWorkShiftParams({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];
}
