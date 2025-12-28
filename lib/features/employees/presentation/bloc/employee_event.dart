import 'package:equatable/equatable.dart';
import '../../../auth/domain/entities/employee_entity.dart';

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

  const CreateEmployeeRequested({
    required this.employee,
    required this.pin,
  });

  @override
  List<Object?> get props => [employee, pin];
}

class DeleteEmployeeRequested extends EmployeeEvent {
  final String id;
  const DeleteEmployeeRequested(this.id);
  @override
  List<Object?> get props => [id];
}
