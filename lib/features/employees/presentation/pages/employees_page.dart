import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_ui/app_scaffold.dart';
import '../../../../di/injection_container.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeeBloc>()..add(const LoadEmployees()),
      child: AppScaffold(
        showBackground: false,
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            }

            if (state is EmployeeError) {
              return Center(child: Text(state.message));
            }

            if (state is EmployeeLoaded) {
              final employees = state.employees;

              return Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implementar creación
                      },
                      icon: const Icon(Icons.add, size: 18),
                      label: const Text('NUEVO EMPLEADO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: GridView.builder(
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 220,
                          childAspectRatio: 1.0,
                          crossAxisSpacing: 24,
                          mainAxisSpacing: 24,
                        ),
                        itemCount: employees.length,
                        itemBuilder: (context, index) {
                          return _ModernEmployeeCard(employee: employees[index]);
                        },
                      ),
                    ),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}

class _ModernEmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;

  const _ModernEmployeeCard({required this.employee});

  @override
  Widget build(BuildContext context) {
    final initials = employee.name[0].toUpperCase() +
        (employee.lastName.isNotEmpty ? employee.lastName[0].toUpperCase() : '');

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.black.withAlpha(15), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Indicador de estado
          Positioned(
            top: 16,
            right: 16,
            child: Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: employee.isActive ? Colors.greenAccent[700] : Colors.grey[400],
                boxShadow: [
                  if (employee.isActive)
                    BoxShadow(
                      color: Colors.greenAccent.withAlpha(100),
                      blurRadius: 4,
                      spreadRadius: 1,
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Avatar minimal
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue[400]!, Colors.blue[700]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withAlpha(40),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      initials,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  employee.fullName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    employee.role.toValue(),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.grey[600],
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Acciones rápidas (Edit/More)
          Positioned(
            bottom: 8,
            right: 8,
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.more_vert, size: 20, color: Colors.black26),
            ),
          ),
        ],
      ),
    );
  }
}
