import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/shared_kernel/role.dart';
import '../../../../di/injection_container.dart';
import '../../../auth/domain/entities/employee_entity.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart' as employee_event;

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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEmployeeDialog(context),
        child: const Icon(Icons.add),
      ),
      body: BlocConsumer<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          } else if (state is EmployeeError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is EmployeeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EmployeeLoaded) {
            if (state.employees.isEmpty) {
              return const Center(child: Text('No hay empleados registrados'));
            }
            return ListView.builder(
              itemCount: state.employees.length,
              itemBuilder: (context, index) {
                final employee = state.employees[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(employee.name[0].toUpperCase()),
                  ),
                  title: Text(employee.fullName),
                  subtitle: Text(employee.role.toValue()),
                  trailing: employee.role.toValue() == 'ADMIN'
                      ? null // No permitir borrar al admin principal por UI simple
                      : IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                             context.read<EmployeeBloc>().add(employee_event.DeleteEmployeeRequested(employee.id));
                          },
                        ),
                );
              },
            );
          }
          return const Center(child: Text('Algo salió mal'));
        },
      ),
    );
  }

  void _showAddEmployeeDialog(BuildContext parentContext) {
    final nameController = TextEditingController();
    final lastNameController = TextEditingController();
    final pinController = TextEditingController();
    final emergencyController = TextEditingController();
    Role selectedRole = Role.staff;

    showDialog(
      context: parentContext,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Nuevo Empleado'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    TextField(
                      controller: lastNameController,
                      decoration: const InputDecoration(labelText: 'Apellido'),
                    ),
                    TextField(
                      controller: emergencyController,
                      decoration: const InputDecoration(labelText: 'Tel. Emergencia'),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<Role>(
                      initialValue: selectedRole,
                      items: const [
                        DropdownMenuItem(value: Role.admin, child: Text('Admin')),
                        DropdownMenuItem(value: Role.staff, child: Text('Staff')),
                        DropdownMenuItem(value: Role.kitchen, child: Text('Cocina')),
                        DropdownMenuItem(value: Role.supervisor, child: Text('Supervisor')),
                      ],
                      onChanged: (val) => setState(() => selectedRole = val!),
                      decoration: const InputDecoration(labelText: 'Rol'),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: pinController,
                      decoration: const InputDecoration(
                        labelText: 'PIN de Acceso (4 dígitos)',
                        helperText: 'Debe ser único',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 4,
                      obscureText: true,
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final employee = EmployeeEntity(
                      id: const Uuid().v4(),
                      name: nameController.text,
                      lastName: lastNameController.text,
                      emergencyPhone: emergencyController.text,
                      role: selectedRole,
                      isActive: true,
                      createdAt: DateTime.now(),
                      updatedAt: DateTime.now(),
                    );
                    
                    // Disparamos el evento en el Bloc padre
                    parentContext.read<EmployeeBloc>().add(
                      employee_event.CreateEmployeeRequested(
                        employee: employee,
                        pin: pinController.text,
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
