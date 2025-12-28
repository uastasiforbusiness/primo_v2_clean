import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/injection_container.dart';
import '../../../auth/domain/entities/employee_entity.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart' as employee_event;
import '../widgets/employee_form_dialog.dart';

class EmployeeListPage extends StatelessWidget {
  const EmployeeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmployeeBloc>()..add(const employee_event.LoadEmployees()),
      child: const _EmployeeListView(),
    );
  }
}

class _EmployeeListView extends StatelessWidget {
  const _EmployeeListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Empleados'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
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
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Cargando empleados...'),
                ],
              ),
            );
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                    const SizedBox(height: 16),
                    Text(
                      'No hay empleados registrados',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return _EmployeeCard(employee: employee);
              },
            );
          }
          return const Center(child: Text('Algo salió mal'));
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
          backgroundColor: _getRoleColor(employee.role.toValue()),
          child: Text(
            employee.name[0].toUpperCase(),
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          employee.fullName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.badge, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(employee.role.toValue()),
              ],
            ),
            if (employee.email != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.email, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(employee.email!),
                ],
              ),
            ],
            if (employee.phone != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(employee.phone!),
                ],
              ),
            ],
          ],
        ),
        trailing: isAdmin
            ? Chip(
                label: const Text('ADMIN', style: TextStyle(fontSize: 10)),
                backgroundColor: Colors.purple[100],
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.blue),
                    onPressed: () => _showEditDialog(context, employee),
                    tooltip: 'Editar',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _confirmDelete(context, employee),
                    tooltip: 'Eliminar',
                  ),
                ],
              ),
      ),
    );
  }

  Color _getRoleColor(String role) {
    switch (role) {
      case 'ADMIN':
        return Colors.purple;
      case 'SUPERVISOR':
        return Colors.orange;
      case 'KITCHEN':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  void _showEditDialog(BuildContext context, EmployeeEntity employee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return EmployeeFormDialog(
          employee: employee,
          onSave: (updatedEmployee, newPin) {
            context.read<EmployeeBloc>().add(
              employee_event.UpdateEmployeeRequested(
                employee: updatedEmployee,
                newPin: newPin,
              ),
            );
          },
        );
      },
    );
  }

  void _confirmDelete(BuildContext context, EmployeeEntity employee) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: Text(
            '¿Está seguro que desea eliminar a ${employee.fullName}?\n\n'
            'Esta acción marcará al empleado como inactivo pero mantendrá sus registros históricos.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<EmployeeBloc>().add(
                  employee_event.DeleteEmployeeRequested(employee.id),
                );
                Navigator.pop(dialogContext);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }
}
