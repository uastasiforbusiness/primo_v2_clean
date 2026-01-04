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

  EmployeeRepositoryImpl({required this.localDataSource, required this.securityService});

  @override
  Future<Either<Failure, List<EmployeeEntity>>> getEmployees() async {
    try {
      final employees = await localDataSource.getEmployees();
      return Right(employees.map((e) => EmployeeModel.fromDrift(e).toEntity()).toList());
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> createEmployee(EmployeeEntity employee, String pinText, {required String actorId}) async {
    try {
      final pepper = await securityService.getMasterPepper();
      final pinSalt = Pin.generateSalt();
      final pin = Pin.fromPlainText(pinText);
      final pinHash = await pin.toHashWithSalt(pinSalt, pepper);
      final pinBlindIndex = await pin.toBlindIndex(pepper);

      final employeeDrift = Employee(
        id: employee.id, name: employee.name, lastName: employee.lastName,
        email: employee.email, phone: employee.phone, emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(), pinHash: pinHash, pinSalt: pinSalt,
        pinBlindIndex: pinBlindIndex, securityVersion: 1, isActive: true,
        createdAt: DateTime.now(), updatedAt: DateTime.now(), hourlyRate: employee.hourlyRate,
      );

      await localDataSource.createEmployee(employeeDrift, performedBy: actorId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateEmployee(EmployeeEntity employee, {String? newPin, required String actorId}) async {
    try {
      String? newPinHash, newPinSalt, newPinBlindIndex;
      if (newPin != null) {
        final pepper = await securityService.getMasterPepper();
        final salt = Pin.generateSalt();
        final pinObj = Pin.fromPlainText(newPin);
        newPinHash = await pinObj.toHashWithSalt(salt, pepper);
        newPinSalt = salt;
        newPinBlindIndex = await pinObj.toBlindIndex(pepper);
      }

      final employeeDrift = Employee(
        id: employee.id, name: employee.name, lastName: employee.lastName,
        email: employee.email, phone: employee.phone, emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(), pinHash: '', pinSalt: '', pinBlindIndex: '',
        securityVersion: employee.securityVersion, isActive: employee.isActive,
        createdAt: employee.createdAt, updatedAt: DateTime.now(), hourlyRate: employee.hourlyRate,
      );

      await localDataSource.updateEmployee(employeeDrift, performedBy: actorId, newPinHash: newPinHash, newPinSalt: newPinSalt, newPinBlindIndex: newPinBlindIndex);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteEmployee(String employeeId, {required String actorId}) async {
    try {
      await localDataSource.deleteEmployee(employeeId, performedBy: actorId);
      return const Right(null);
    } catch (e) {
      return Left(DatabaseFailure(message: e.toString()));
    }
  }
}
