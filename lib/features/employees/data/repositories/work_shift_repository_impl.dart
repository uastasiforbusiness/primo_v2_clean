import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/work_shift_entity.dart';
import '../../domain/repositories/work_shift_repository.dart';
import '../datasources/employee_local_datasource.dart';
import '../models/work_shift_model.dart';

class WorkShiftRepositoryImpl implements WorkShiftRepository {
  final EmployeeLocalDataSource localDataSource;

  WorkShiftRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, WorkShiftEntity>> clockIn(String employeeId) async {
    try {
      // In a real scenario, we might want to fetch the employee's current hourly rate first
      // For now, we'll assume the datasource handles retrieval or we pass null if not available immediately
      // But looking at our datasource interface, we need to pass hourlyRate.
      // Let's first fetch the employee to get the hourly rate.
      // However, the datasource clockIn signature expects hourlyRate.
      // To keep it simple and following Clean Architecture, the use case should probably coordinate this,
      // or the repository can do a quick lookup.
      // For now, let's just pass null or update the interface if needed.
      // Wait, the user asked to use the *new* hourlyRate.
      // So we should retrieve the employee first.

      final employees = await localDataSource.getEmployees();
      // This is inefficient if we have many employees, but for POS it's fine.
      // Better: add getEmployeeById to datasource.
      // But we can just filter for now or rely on the fact that we might have the employee object in the UI.
      // Actually, the best place to get the hourly rate is from the EmployeeEntity passed to the Bloc.
      // But the repository method only takes employeeId.
      // Let's fetch the employee here.

      final employee = employees.firstWhere((e) => e.id == employeeId);
      final hourlyRate = employee.hourlyRate;

      final shift = await localDataSource.clockIn(employeeId, hourlyRate);
      return Right(WorkShiftModel.fromDrift(shift));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkShiftEntity>> clockOut(String employeeId) async {
    try {
      final shift = await localDataSource.clockOut(employeeId);
      return Right(WorkShiftModel.fromDrift(shift));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, WorkShiftEntity?>> getActiveWorkShift(String employeeId) async {
    try {
      final shift = await localDataSource.getActiveWorkShift(employeeId);
      if (shift == null) return const Right(null);
      return Right(WorkShiftModel.fromDrift(shift));
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<WorkShiftEntity>>> getWorkShifts(String employeeId) async {
    try {
      final shifts = await localDataSource.getWorkShifts(employeeId);
      final entities = shifts.map(WorkShiftModel.fromDrift).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
