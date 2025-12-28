import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/employee_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, EmployeeEntity>> loginWithPin(String pin);
}
