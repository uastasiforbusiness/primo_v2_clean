import 'package:primo_v2/core/entities/employee_entity.dart';

import '../../../../core/shared_kernel/role.dart';
import '../../../database/data/app_database.dart';

class EmployeeModel extends EmployeeEntity {
  const EmployeeModel({
    required super.id,
    required super.name,
    required super.lastName,
    super.email,
    super.phone,
    required super.emergencyPhone,
    required super.role,
    required super.isActive,
    required super.createdAt,
    required super.updatedAt,
  });

  factory EmployeeModel.fromDrift(Employee employee) {
    return EmployeeModel(
      id: employee.id,
      name: employee.name,
      lastName: employee.lastName,
      email: employee.email,
      phone: employee.phone,
      emergencyPhone: employee.emergencyPhone,
      role: Role.fromString(employee.role),
      isActive: employee.isActive,
      createdAt: employee.createdAt,
      updatedAt: employee.updatedAt,
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
      role: role,
      isActive: isActive,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
