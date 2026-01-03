import 'package:equatable/equatable.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class LoginWithPinRequested extends AuthEvent {
  final String pin;
  const LoginWithPinRequested(this.pin);
  @override
  List<Object?> get props => [pin];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}

class ConfirmClockInRequested extends AuthEvent {
  final EmployeeEntity employee;
  const ConfirmClockInRequested(this.employee);
  @override
  List<Object?> get props => [employee];
}
