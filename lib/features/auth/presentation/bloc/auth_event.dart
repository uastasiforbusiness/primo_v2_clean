import 'package:equatable/equatable.dart';

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

class ClockInRequested extends AuthEvent {
  final String employeeId;
  final double initialCash;

  const ClockInRequested({
    required this.employeeId,
    required this.initialCash,
  });

  @override
  List<Object?> get props => [employeeId, initialCash];
}

class ClockOutRequested extends AuthEvent {
  final String shiftId;
  final double finalCash;

  const ClockOutRequested({
    required this.shiftId,
    required this.finalCash,
  });

  @override
  List<Object?> get props => [shiftId, finalCash];
}

class StartBreakRequested extends AuthEvent {
  final String shiftId;

  const StartBreakRequested(this.shiftId);

  @override
  List<Object?> get props => [shiftId];
}

class EndBreakRequested extends AuthEvent {
  final String shiftId;

  const EndBreakRequested(this.shiftId);

  @override
  List<Object?> get props => [shiftId];
}

class LogoutRequested extends AuthEvent {
  const LogoutRequested();
}

class CheckAuthStatus extends AuthEvent {
  const CheckAuthStatus();
}
