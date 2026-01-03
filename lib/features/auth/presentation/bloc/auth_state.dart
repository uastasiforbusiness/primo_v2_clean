import 'package:equatable/equatable.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/features/employees/domain/entities/work_shift_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAuthenticated extends AuthState {
  final EmployeeEntity employee;
  final WorkShiftEntity? workShift;

  const AuthAuthenticated({
    required this.employee,
    this.workShift,
  });

  @override
  List<Object?> get props => [employee, workShift];
}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

class AuthClockInRequired extends AuthState {
  final EmployeeEntity employee;
  const AuthClockInRequired({required this.employee});
  @override
  List<Object?> get props => [employee];
}
