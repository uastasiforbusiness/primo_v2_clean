import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_local_datasource.dart';
import '../models/employee_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, EmployeeEntity>> loginWithPin(String pin) async {
    try {
      final employee = await localDataSource.loginWithPin(pin);
      final model = EmployeeModel.fromDrift(employee);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(DatabaseFailure(message: 'Unexpected error: ${e.toString()}'));
    }
  }
}
