import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class LoginWithPinUseCase {
  final AuthRepository repository;

  LoginWithPinUseCase(this.repository);

  Future<Either<Failure, EmployeeEntity>> call(String pin) async {
    // Validate PIN format
    if (pin.length != 4) {
      return const Left(
        ValidationFailure(message: 'PIN must be 4 digits'),
      );
    }

    if (!RegExp(r'^\d{4}$').hasMatch(pin)) {
      return const Left(
        ValidationFailure(message: 'PIN must contain only numbers'),
      );
    }

    return await repository.loginWithPin(pin);
  }
}
