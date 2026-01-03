import 'package:dartz/dartz.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/security/security_service.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../../infrastructure/database/app_database.dart';
import '../../../auth/data/models/employee_model.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource localDataSource;
  final SecurityService securityService;

  EmployeeRepositoryImpl({
    required this.localDataSource,
    required this.securityService,
  });

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees() async {
    try {
      final employees = await localDataSource.getEmployees();
      final entities = employees.map((e) => EmployeeModel.fromDrift(e).toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createEmployee(EmployeeEntity employee, String pinText) async {
    try {
      // 1. Get Security Secrets
      final pepper = await securityService.getMasterPepper();
      final pinSalt = Pin.generateSalt();

      // 2. Perform Cryptography
      final pin = Pin.fromPlainText(pinText);
      final pinHash = await pin.toHashWithSalt(pinSalt, pepper);
      final pinBlindIndex = await pin.toBlindIndex(pepper);

      // 3. Create Data Object
      final employeeDrift = Employee(
        id: employee.id,
        name: employee.name,
        lastName: employee.lastName,
        email: employee.email,
        phone: employee.phone,
        emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(),
        pinHash: pinHash,
        pinSalt: pinSalt,
        pinBlindIndex: pinBlindIndex,
        securityVersion: 1, // Start with version 1 (Argon2id)
        isActive: true, // Default to true on create
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        hourlyRate: employee.hourlyRate,
      );

      await localDataSource.createEmployee(employeeDrift);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(EmployeeEntity employee, {String? newPin}) async {
    try {
      String? newPinHash;
      String? newPinSalt;
      String? newPinBlindIndex;
      int? newSecurityVersion;

      if (newPin != null) {
        final pepper = await securityService.getMasterPepper();
        final salt = Pin.generateSalt();
        final pinObj = Pin.fromPlainText(newPin);

        newPinHash = await pinObj.toHashWithSalt(salt, pepper);
        newPinSalt = salt;
        newPinBlindIndex = await pinObj.toBlindIndex(pepper);
        newSecurityVersion = 1;
      }

      // We pass the existing employee data, but datasource might not need everything if using partial update logic
      // However, createEmployee() in repo logic passed a full object.
      // Here we construct a Drift Employee object to pass Identity.
      final employeeDrift = Employee(
        id: employee.id,
        name: employee.name,
        lastName: employee.lastName,
        email: employee.email,
        phone: employee.phone,
        emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(),
        // Pass existing hashed values (though they won't be used if we provide new ones via params)
        // But to satisfy constructor we need strings. Passing empty string or existing from entity would be better
        // if entity had them. Entity doesn't have secrets.
        // We can pass empty, assuming DataSource uses new params if provided. Update logic in datasource uses specific params.
        pinHash: '',
        pinSalt: '',
        pinBlindIndex: '',
        securityVersion: employee.securityVersion,
        isActive: employee.isActive,
        createdAt: employee.createdAt,
        updatedAt: DateTime.now(),
        hourlyRate: employee.hourlyRate,
      );

      await localDataSource.updateEmployee(
        employeeDrift,
        newPinHash: newPinHash,
        newPinSalt: newPinSalt,
        newPinBlindIndex: newPinBlindIndex,
        newSecurityVersion: newSecurityVersion,
      );
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String employeeId) async {
    try {
      await localDataSource.deleteEmployee(employeeId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
