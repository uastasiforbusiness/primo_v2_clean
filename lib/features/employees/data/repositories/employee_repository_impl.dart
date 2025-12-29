import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/shared_kernel/pin.dart';
import '../../../auth/data/models/employee_model.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../../../database/data/app_database.dart';
import '../../domain/repositories/employee_repository.dart';
import '../datasources/employee_local_datasource.dart';

class EmployeeRepositoryImpl implements EmployeeRepository {
  final EmployeeLocalDataSource localDataSource;

  EmployeeRepositoryImpl({required this.localDataSource});

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
  Future<Either<Failure, void>> createEmployee(EmployeeEntity employee, String pin) async {
    try {
      final pinHash = Pin.fromPlainText(pin).toHash();

      final employeeDrift = Employee(
        id: employee.id,
        name: employee.name,
        lastName: employee.lastName,
        email: employee.email,
        phone: employee.phone,
        emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(),
        pinHash: pinHash,
        isActive: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
      // Hash new PIN if provided
      final pinHash = newPin != null ? Pin.fromPlainText(newPin).toHash() : null;

      // Note: We pass a minimal Employee object for update
      // The datasource will handle partial updates via EmployeesCompanion
      final employeeDrift = Employee(
        id: employee.id,
        name: employee.name,
        lastName: employee.lastName,
        email: employee.email,
        phone: employee.phone,
        emergencyPhone: employee.emergencyPhone,
        role: employee.role.toValue(),
        pinHash: '', // Placeholder, actual PIN handled by datasource
        isActive: employee.isActive,
        createdAt: employee.createdAt,
        updatedAt: DateTime.now(),
      );

      await localDataSource.updateEmployee(employeeDrift, newPinHash: pinHash);
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
