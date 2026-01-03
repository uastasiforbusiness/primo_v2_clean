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
import '../../../../core/shared_ui/premium_panel.dart';
import '../bloc/audit_bloc.dart';
import '../bloc/audit_event.dart';
import '../bloc/audit_state.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/entities/audit_event_entity.dart';
import 'package:intl/intl.dart';

enum AuditCategory { employees, inventory, sales }

class AuditPage extends StatefulWidget {
  const AuditPage({super.key});

  @override
  State<AuditPage> createState() => _AuditPageState();
}

class _AuditPageState extends State<AuditPage> {
  AuditCategory _selectedCategory = AuditCategory.employees;
  late final EmployeeBloc _employeeBloc;
  late final AuditBloc _auditBloc;
  EmployeeEntity? _selectedEmployee;

  @override
  void initState() {
    super.initState();
    _employeeBloc = sl<EmployeeBloc>()..add(const LoadEmployees());
    _auditBloc = sl<AuditBloc>();
  }

  @override
  void dispose() {
    _employeeBloc.close();
    _auditBloc.close();
    super.dispose();
  }

  void _onEmployeeSelected(EmployeeEntity employee) {
    setState(() {
      _selectedEmployee = employee;
    });
    _auditBloc.add(ApplyAuditFilter(AuditFilter(employeeId: employee.id)));
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _employeeBloc),
        BlocProvider.value(value: _auditBloc),
      ],
      child: AppScaffold(
        showBackground: false,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Panel Principal Izquierdo
            Expanded(
              child: Padding(
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

            // Panel Lateral Derecho de Auditoría
            PremiumPanel(
              isVisible: _selectedEmployee != null,
              width: 450,
              child: _buildAuditPanel(),
            ),
          ],
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
                    isSelected: _selectedEmployee?.id == employee.id,
                    onTap: () => _onEmployeeSelected(employee),
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

  Widget _buildAuditPanel() {
    if (_selectedEmployee == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header del Panel
        Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'AUDITORÍA DE ACTIVIDAD',
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            color: Colors.blue[800],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedEmployee!.fullName,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1A1A1A),
                          letterSpacing: -0.5,
                        ),
                      ),
                      Text(
                        _selectedEmployee!.role.toValue().toUpperCase(),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.grey[500],
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                  Material(
                    color: Colors.grey[100],
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => setState(() => _selectedEmployee = null),
                      icon: const Icon(Icons.close, size: 20),
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const Divider(height: 1),

        // Historial de Eventos
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                Row(
                  children: [
                    Icon(Icons.history, size: 16, color: Colors.grey[400]),
                    const SizedBox(width: 8),
                    Text(
                      'HISTORIAL RECIENTE',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: BlocBuilder<AuditBloc, AuditState>(
                    builder: (context, state) {
                      if (state is AuditLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      if (state is AuditLoaded) {
                        if (state.events.isEmpty) {
                          return _buildNoActivity();
                        }
                        return ListView.separated(
                          itemCount: state.events.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          padding: const EdgeInsets.only(bottom: 32),
                          itemBuilder: (context, index) {
                            final event = state.events[index];
                            return _buildAuditItem(event);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAuditItem(AuditEventEntity event) {
    final isClockIn = event.eventType.toLowerCase() == 'clock_in';
    final isClockOut = event.eventType.toLowerCase() == 'clock_out';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isClockIn ? Colors.blue[100]! : Colors.grey[200]!,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(5),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isClockIn
                  ? Colors.blue[600]
                  : isClockOut
                      ? Colors.orange[600]
                      : Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isClockIn
                  ? Icons.login_rounded
                  : isClockOut
                      ? Icons.logout_rounded
                      : Icons.info_outline,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isClockIn
                      ? 'REGISTRO DE ENTRADA'
                      : isClockOut
                          ? 'REGISTRO DE SALIDA'
                          : event.eventType.replaceAll('_', ' ').toUpperCase(),
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isClockIn ? Colors.blue[900] : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('hh:mm a').format(event.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('dd MMM, yyyy').format(event.createdAt),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.grey[300], size: 20),
        ],
      ),
    );
  }

  Widget _buildNoActivity() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 48, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'SIN ACTIVIDAD RECIENTE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Colors.black26,
            ),
          ),
        ],
      ),
    );
  }
}
