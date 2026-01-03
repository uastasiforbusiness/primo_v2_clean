import 'package:dartz/dartz.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/money.dart';
import '../../domain/entities/shift_entity.dart';
import '../../domain/repositories/shift_repository.dart';
import '../datasources/shift_local_datasource.dart';
import '../models/shift_model.dart';

class ShiftRepositoryImpl implements ShiftRepository {
  final ShiftLocalDataSource localDataSource;

  ShiftRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, ShiftEntity>> clockIn({
    required String employeeId,
    required Money initialCash,
  }) async {
    try {
      final shift = await localDataSource.clockIn(
        employeeId: employeeId,
        initialCash: initialCash.amount,
      );
      final model = ShiftModel.fromDrift(shift);
      return Right(model.toEntity());
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> clockOut({
    required String shiftId,
    required Money finalCash,
  }) async {
    try {
      await localDataSource.clockOut(
        shiftId: shiftId,
        finalCash: finalCash.amount,
      );
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, ShiftEntity?>> getActiveShift(String employeeId) async {
    try {
      final shift = await localDataSource.getActiveShift(employeeId);
      if (shift == null) {
        return const Right(null);
      }
      final model = ShiftModel.fromDrift(shift);
      return Right(model.toEntity());
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> startBreak(String shiftId) async {
    try {
      await localDataSource.startBreak(shiftId);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> endBreak(String shiftId) async {
    try {
      await localDataSource.endBreak(shiftId);
      return const Right(null);
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> hasActiveBreak(String shiftId) async {
    try {
      final hasBreak = await localDataSource.hasActiveBreak(shiftId);
      return Right(hasBreak);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
