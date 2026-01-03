import 'package:equatable/equatable.dart';
import '../../domain/entities/shift_entity.dart';

abstract class ShiftState extends Equatable {
  const ShiftState();
  @override
  List<Object?> get props => [];
}

class ShiftInitial extends ShiftState {}
class ShiftLoading extends ShiftState {}

class ShiftActive extends ShiftState {
  final ShiftEntity shift;
  const ShiftActive(this.shift);
  @override
  List<Object?> get props => [shift];
}

class ShiftOnBreak extends ShiftState {
  final ShiftEntity shift;
  const ShiftOnBreak(this.shift);
  @override
  List<Object?> get props => [shift];
}

class ShiftInactive extends ShiftState {
  // Estado cuando el empleado está logueado pero NO ha iniciado turno
}

class ShiftError extends ShiftState {
  final String message;
  const ShiftError(this.message);
  @override
  List<Object?> get props => [message];
}
