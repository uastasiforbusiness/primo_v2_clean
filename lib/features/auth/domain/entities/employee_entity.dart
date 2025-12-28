import 'package:equatable/equatable.dart';
import '../../../../core/shared_kernel/role.dart';

class EmployeeEntity extends Equatable {
  final String id;
  final String name;
  final String lastName;
  final String? email;
  final String? phone;
  final String emergencyPhone;
  final Role role;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const EmployeeEntity({
    required this.id,
    required this.name,
    required this.lastName,
    this.email,
    this.phone,
    required this.emergencyPhone,
    required this.role,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  String get fullName => '$name $lastName';

  @override
  List<Object?> get props => [
        id,
        name,
        lastName,
        email,
        phone,
        emergencyPhone,
        role,
        isActive,
        createdAt,
        updatedAt,
      ];
}
