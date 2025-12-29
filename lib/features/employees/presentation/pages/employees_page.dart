import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../di/injection_container.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart' as employee_event;
import '../bloc/employee_state.dart';
import '../widgets/employee_form_dialog.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmployeeBloc>()..add(const employee_event.LoadEmployees()),
      child: const _EmployeesView(),
    );
  }
}

class _EmployeesView extends StatelessWidget {
  const _EmployeesView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.goNamed('dashboard');
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showEmployeeDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Empleado'),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.white),
                    const SizedBox(width: 12),
                    Text(state.message),
                  ],
                ),
                backgroundColor: Colors.green,
              ),
            );
          } else if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.error, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(child: Text(state.message)),
                  ],
                ),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return const Center(child: Text('No hay empleados registrados'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                return _EmployeeCard(employee: state.employees[index]);
              },
            );
          }

          if (state is EmployeeOperationSuccess || state is EmployeeError) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void _showEmployeeDialog(BuildContext parentContext) {
    showDialog(
      context: parentContext,
      builder: (context) {
        return EmployeeFormDialog(
          onSave: (employee, pin) {
            parentContext.read<EmployeeBloc>().add(
                  employee_event.CreateEmployeeRequested(
                    employee: employee,
                    pin: pin!,
                  ),
                );
          },
        );
      },
    );
  }
}

class _EmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;

  const _EmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    final isAdmin = employee.id == 'admin-001';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: Text(
            employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(employee.fullName),
        subtitle: Text(employee.role.toValue()),
        trailing: isAdmin
            ? const Chip(label: Text('ADMIN'))
            : IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  context.read<EmployeeBloc>().add(
                        employee_event.DeleteEmployeeRequested(employee.id),
                      );
                },
              ),
      ),
    );
  }
}
