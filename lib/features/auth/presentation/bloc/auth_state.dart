import 'package:equatable/equatable.dart';
import '../../domain/entities/employee_entity.dart';
import '../../domain/entities/shift_entity.dart';

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

class AuthLoginSuccess extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity? activeShift;

  const AuthLoginSuccess({
    required this.employee,
    this.activeShift,
  });

  @override
  List<Object?> get props => [employee, activeShift];
}

class AuthAuthenticated extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity shift;

  const AuthAuthenticated({
    required this.employee,
    required this.shift,
  });

  @override
  List<Object?> get props => [employee, shift];
}

class AuthOnBreak extends AuthState {
  final EmployeeEntity employee;
  final ShiftEntity shift;

  const AuthOnBreak({
    required this.employee,
    required this.shift,
  });

  @override
  List<Object?> get props => [employee, shift];
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
