import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/shared_ui/app_scaffold.dart';
import '../../../../di/injection_container.dart';
import '../../../employees/presentation/bloc/employee_bloc.dart';
import '../../../employees/presentation/bloc/employee_event.dart';
import '../../../employees/presentation/bloc/employee_state.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_ui/premium_card.dart';
import '../../../../core/shared_kernel/role.dart';

enum AuditCategory { employees, inventory, sales }

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  AuditCategory _selectedCategory = AuditCategory.employees;
  late final EmployeeBloc _employeeBloc;

  @override
  void initState() {
    super.initState();
    _employeeBloc = sl<EmployeeBloc>()..add(const LoadEmployees());
  }

  @override
  void dispose() {
    _employeeBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _employeeBloc,
      child: AppScaffold(
        showBackground: false,
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _buildTopItem(
                    category: AuditCategory.employees,
                    icon: Icons.people_outline,
                    label: 'Empleados',
                  ),
                  const SizedBox(width: 8),
                  _buildTopItem(
                    category: AuditCategory.inventory,
                    icon: Icons.inventory_2_outlined,
                    label: 'Inventario',
                  ),
                  const SizedBox(width: 8),
                  _buildTopItem(
                    category: AuditCategory.sales,
                    icon: Icons.shopping_cart_outlined,
                    label: 'Venta',
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Expanded(
                child: _buildCategoryContent(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopItem({
    required AuditCategory category,
    required IconData icon,
    required String label,
  }) {
    final bool isSelected = _selectedCategory == category;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedCategory = category),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[700] : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.blue.withAlpha(80),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? Colors.white : Colors.grey[500],
              ),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  color: isSelected ? Colors.white : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryContent() {
    switch (_selectedCategory) {
      case AuditCategory.employees:
        return _buildEmployeeList();
      case AuditCategory.inventory:
        return const Center(child: Text('CONTENIDO DE AUDITORÍA DE INVENTARIO'));
      case AuditCategory.sales:
        return const Center(child: Text('CONTENIDO DE AUDITORÍA DE VENTAS'));
    }
  }

  Widget _buildEmployeeList() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is EmployeeError) {
          return Center(child: Text('Error: ${state.message}'));
        } else if (state is EmployeeLoaded) {
          if (state.employees.isEmpty) {
            return const Center(child: Text('No hay empleados registrados'));
          }
          return SingleChildScrollView(
            child: Wrap(
              spacing: 24,
              runSpacing: 24,
              children: state.employees.map((employee) {
                final initials = employee.name[0].toUpperCase() +
                    (employee.lastName.isNotEmpty ? employee.lastName[0].toUpperCase() : '');

                return SizedBox(
                  width: 160, // Fixed size to match EmployeesPage
                  height: 160,
                  child: PremiumCard(
                    title: employee.fullName,
                    subtitle: employee.role.toValue(),
                    avatarText: initials,
                    isActive: employee.isActive,
                    isSelected:
                        false, // In Audit we just view, so no selection state needed for now
                    onTap: () {
                      // Action when clicking an employee in audit
                    },
                  ),
                );
              }).toList(),
            ),
          );
        }
        return const SizedBox();
      },
    );
  }

  // Deleting the _buildEmployeeCard helper as we are using PremiumCard now
}
