import 'package:equatable/equatable.dart';

enum RoleType {
  admin,
  supervisor,
  staff,
  kitchen,
}

class Role extends Equatable {
  final RoleType type;

  const Role._(this.type);

  factory Role.fromString(String value) {
    switch (value.toUpperCase()) {
      case 'ADMIN':
        return const Role._(RoleType.admin);
      case 'SUPERVISOR':
        return const Role._(RoleType.supervisor);
      case 'STAFF':
        return const Role._(RoleType.staff);
      case 'KITCHEN':
        return const Role._(RoleType.kitchen);
      default:
        throw ArgumentError('Invalid role: $value');
    }
  }

  static const Role admin = Role._(RoleType.admin);
  static const Role supervisor = Role._(RoleType.supervisor);
  static const Role staff = Role._(RoleType.staff);
  static const Role kitchen = Role._(RoleType.kitchen);

  String toValue() {
    switch (type) {
      case RoleType.admin:
        return 'ADMIN';
      case RoleType.supervisor:
        return 'SUPERVISOR';
      case RoleType.staff:
        return 'STAFF';
      case RoleType.kitchen:
        return 'KITCHEN';
    }
  }

  bool get canManageEmployees => type == RoleType.admin || type == RoleType.supervisor;
  bool get canAccessReports => type == RoleType.admin || type == RoleType.supervisor;
  bool get canOperatePOS => type == RoleType.admin || type == RoleType.staff;
  bool get canAccessKitchen => type == RoleType.admin || type == RoleType.kitchen;

  @override
  List<Object?> get props => [type];
}
