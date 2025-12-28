import 'package:equatable/equatable.dart';

abstract class ShiftEvent extends Equatable {
  const ShiftEvent();
  @override
  List<Object?> get props => [];
}

class LoadActiveShift extends ShiftEvent {
  final String employeeId;
  const LoadActiveShift(this.employeeId);
  @override
  List<Object?> get props => [employeeId];
}

class ClockInRequested extends ShiftEvent {
  final String employeeId;
  final double initialCash;
  const ClockInRequested({required this.employeeId, required this.initialCash});
  @override
  List<Object?> get props => [employeeId, initialCash];
}

class ClockOutRequested extends ShiftEvent {
  final String shiftId;
  final double finalCash;
  const ClockOutRequested({required this.shiftId, required this.finalCash});
  @override
  List<Object?> get props => [shiftId, finalCash];
}

class StartBreakRequested extends ShiftEvent {
  final String shiftId;
  const StartBreakRequested(this.shiftId);
  @override
  List<Object?> get props => [shiftId];
}

class EndBreakRequested extends ShiftEvent {
  final String shiftId;
  const EndBreakRequested(this.shiftId);
  @override
  List<Object?> get props => [shiftId];
}
