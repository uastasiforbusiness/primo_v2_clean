import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/shared_kernel/role.dart';
import '../../../../infrastructure/database/app_database.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.lastName,
    super.email,
    super.phone,
    required super.emergencyPhone,
    super.hourlyRate,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
    super.securityVersion,
  });

  factory EmployeeModel.fromDrift(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      lastName: employee.lastName,
      email: employee.email,
      phone: employee.phone,
      emergencyPhone: employee.emergencyPhone,
      hourlyRate: employee.hourlyRate,
      role: Role.fromString(employee.role),
      isActive: employee.isActive,
      createdAt: employee.createdAt,
      updatedAt: employee.updatedAt,
      securityVersion: employee.securityVersion,
    );
  }

  EmployeeEntity toEntity() {
    return EmployeeEntity(
      id: id,
      name: name,
      lastName: lastName,
      email: email,
      phone: phone,
      emergencyPhone: emergencyPhone,
      hourlyRate: hourlyRate,
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
      securityVersion: securityVersion,
    );
  }
}
