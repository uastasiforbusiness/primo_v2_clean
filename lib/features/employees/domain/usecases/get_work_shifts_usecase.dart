import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_shift_entity.dart';
import '../../domain/repositories/work_shift_repository.dart';

class GetWorkShiftsUseCase {
  final WorkShiftRepository repository;

  GetWorkShiftsUseCase(this.repository);

  Future<Either<Failure, List<WorkShiftEntity>>> call(GetWorkShiftsParams params) async {
    return await repository.getWorkShifts(params.employeeId);
  }
}

class GetWorkShiftsParams extends Equatable {
  final String employeeId;

  const GetWorkShiftsParams({required this.employeeId});

  @override
  List<Object?> get props => [employeeId];
}
