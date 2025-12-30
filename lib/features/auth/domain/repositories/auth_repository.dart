import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/error/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, EmployeeEntity>> loginWithPin(String pin);
}
