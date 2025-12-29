import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_employee_usecase.dart';
import '../../domain/usecases/delete_employee_usecase.dart';
import '../../domain/usecases/get_employees_usecase.dart';
import '../../domain/usecases/update_employee_usecase.dart';
import 'employee_event.dart' as employee_event;
import 'employee_state.dart'; // ✅ IMPORTANTE: Usamos el archivo externo, no redefinimos aquí.

class EmployeeBloc extends Bloc<employee_event.EmployeeEvent, EmployeeState> {
  final GetEmployeesUseCase getEmployeesUseCase;
  final CreateEmployeeUseCase createEmployeeUseCase;
  final UpdateEmployeeUseCase updateEmployeeUseCase;
  final DeleteEmployeeUseCase deleteEmployeeUseCase;

  EmployeeBloc({
    required this.getEmployeesUseCase,
    required this.createEmployeeUseCase,
    required this.updateEmployeeUseCase,
    required this.deleteEmployeeUseCase,
  }) : super(EmployeeInitial()) {
    on<employee_event.LoadEmployees>(_onLoadEmployees);
    on<employee_event.CreateEmployeeRequested>(_onCreateEmployee);
    on<employee_event.UpdateEmployeeRequested>(_onUpdateEmployee);
    on<employee_event.DeleteEmployeeRequested>(_onDeleteEmployee);
  }

  Future<void> _onLoadEmployees(
      employee_event.LoadEmployees event, Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    final result = await getEmployeesUseCase();
    result.fold(
      (failure) => emit(EmployeeError(failure.message)),
      (employees) => emit(EmployeeLoaded(employees)),
    );
  }

  Future<void> _onCreateEmployee(employee_event.CreateEmployeeRequested event,
      Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    final result = await createEmployeeUseCase(event.employee, event.pin);

    await result.fold(
      (failure) async => emit(EmployeeError(failure.message)),
      (_) async {
        emit(const EmployeeOperationSuccess('Empleado creado exitosamente'));
        add(const employee_event.LoadEmployees());
      },
    );
  }

  Future<void> _onUpdateEmployee(employee_event.UpdateEmployeeRequested event,
      Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    final result =
        await updateEmployeeUseCase(event.employee, newPin: event.newPin);

    await result.fold(
      (failure) async => emit(EmployeeError(failure.message)),
      (_) async {
        emit(const EmployeeOperationSuccess('Empleado actualizado exitosamente'));
        add(const employee_event.LoadEmployees());
      },
    );
  }

  Future<void> _onDeleteEmployee(employee_event.DeleteEmployeeRequested event,
      Emitter<EmployeeState> emit) async {
    emit(EmployeeLoading());
    final result = await deleteEmployeeUseCase(event.id);

    await result.fold(
      (failure) async => emit(EmployeeError(failure.message)),
      (_) async {
        emit(const EmployeeOperationSuccess('Empleado eliminado exitosamente'));
        add(const employee_event.LoadEmployees());
      },
    );
  }
}
