import 'package:equatable/equatable.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';

abstract class EmployeeEvent extends Equatable {
  const EmployeeEvent();
  @override
  List<Object?> get props => [];
}

class LoadEmployees extends EmployeeEvent {
  const LoadEmployees();
}

class CreateEmployeeRequested extends EmployeeEvent {
  final EmployeeEntity employee;
  final String pin;
  final String actorId;

  const CreateEmployeeRequested({
    required this.employee,
    required this.pin,
    required this.actorId,
  });

  @override
  List<Object?> get props => [employee, pin, actorId];
}

class UpdateEmployeeRequested extends EmployeeEvent {
  final EmployeeEntity employee;
  final String? newPin;
  final String actorId;

  const UpdateEmployeeRequested({
    required this.employee,
    this.newPin,
    required this.actorId,
  });

  @override
  List<Object?> get props => [employee, newPin, actorId];
}

class DeleteEmployeeRequested extends EmployeeEvent {
  final String id;
  final String actorId;
  const DeleteEmployeeRequested(this.id, {required this.actorId});
  @override
  List<Object?> get props => [id, actorId];
}
