import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/core/presentation/widgets/app_scaffold.dart';

import '../../../../di/injection_container.dart';
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
    return AppScaffold(
      body: Row(
        children: [
          // Columna Central: Lista de Empleados
          Expanded(
            flex: 3,
            child: _buildMainSection(context),
          ),
          // Divisor vertical
          const VerticalDivider(width: 1, thickness: 1),
          // Columna Derecha: Acciones Rápidas / Detalles
          Expanded(
            flex: 1,
            child: _buildActionSection(context),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Gestión de Empleados',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Buscar empleado...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: BlocConsumer<EmployeeBloc, EmployeeState>(
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
              }

              if (state is EmployeeLoaded) {
                if (state.employees.isEmpty) {
                  return const Center(child: Text('No hay empleados registrados'));
                }
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: state.employees.length,
                  itemBuilder: (context, index) {
                    return _EmployeeCard(employee: state.employees[index]);
                  },
                );
              }

              return const Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionSection(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Acciones',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () => _showEmployeeDialog(context),
              icon: const Icon(Icons.add),
              label: const Text('NUEVO EMPLEADO', style: TextStyle(fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
          const SizedBox(height: 40),
          const Text(
            'Resumen',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          _buildSummaryItem('Total Empleados', '12'),
          _buildSummaryItem('Administradores', '2'),
          _buildSummaryItem('Cajeros', '10'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
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
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  child: Text(
                    employee.name.isNotEmpty ? employee.name[0].toUpperCase() : '?',
                    style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                  ),
                ),
                const Spacer(),
                if (!isAdmin)
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20),
                    onPressed: () {
                      context.read<EmployeeBloc>().add(
                            employee_event.DeleteEmployeeRequested(employee.id),
                          );
                    },
                  ),
              ],
            ),
            const Spacer(),
            Text(
              employee.fullName,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              employee.role.toValue(),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}
