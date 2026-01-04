import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_ui/app_scaffold.dart';
import '../../../../core/shared_ui/premium_card.dart';
import '../../../../core/shared_ui/premium_panel.dart';
import '../../../../di/injection_container.dart';
import '../../../employees/presentation/bloc/employee_bloc.dart';
import '../../../employees/presentation/bloc/employee_event.dart';
import '../../../employees/presentation/bloc/employee_state.dart';
import '../../domain/entities/audit_event_entity.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../bloc/audit_bloc.dart';
import '../bloc/audit_event.dart';
import '../bloc/audit_state.dart';

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
  AuditEventEntity? _selectedEvent;

  @override
  void initState() {
    super.initState();
    _employeeBloc = sl<EmployeeBloc>()..add(const LoadEmployees());
    _auditBloc = sl<AuditBloc>();
  }

  @override
  Future<void> dispose() async {
    await _employeeBloc.close();
    await _auditBloc.close();
    super.dispose();
  }

  void _onEmployeeSelected(EmployeeEntity employee) {
    setState(() {
      _selectedEmployee = employee;
      _selectedEvent = null;
    });
    _auditBloc.add(
      ApplyAuditFilter(
        AuditFilter(
          employeeId: employee.id,
          eventType: null,
          startDate: null,
          endDate: null,
        ),
      ),
    );
  }

  void _onEventSelected(AuditEventEntity event) {
    setState(() {
      _selectedEvent = event;
      _selectedEmployee = null;
    });
  }

  void _onCategoryChanged(AuditCategory category) {
    setState(() {
      _selectedCategory = category;
      _selectedEmployee = null;
      _selectedEvent = null;
    });

    // Cargar eventos según la categoría
    if (category == AuditCategory.inventory) {
      _auditBloc.add(const ApplyAuditFilter(AuditFilter(eventType: 'inventory_')));
    } else if (category == AuditCategory.sales) {
      _auditBloc.add(const ApplyAuditFilter(AuditFilter(eventType: 'shift_')));
    } else {
      _auditBloc.add(const ClearAuditFilters());
    }
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
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
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
                    ),
                    const SizedBox(height: 32),
                    Expanded(
                      child: _buildCategoryContent(),
                    ),
                  ],
                ),
              ),
            ),

            PremiumPanel(
              isVisible: _selectedEmployee != null || _selectedEvent != null,
              width: 320,
              child: _selectedEmployee != null ? _buildAuditPanel() : _buildEventDetailPanel(),
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
        onTap: () => _onCategoryChanged(category),
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
        return _buildGenericAuditList('AUDITORÍA DE INVENTARIO', Icons.inventory_2_outlined);
      case AuditCategory.sales:
        return _buildGenericAuditList('AUDITORÍA DE VENTAS', Icons.shopping_cart_outlined);
    }
  }

  Widget _buildGenericAuditList(String title, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 24, color: Colors.blue[800]),
            const SizedBox(width: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A1A),
                letterSpacing: -0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Expanded(
          child: BlocBuilder<AuditBloc, AuditState>(
            builder: (context, state) {
              if (state is AuditLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is AuditLoaded) {
                if (state.events.isEmpty) {
                  return _buildNoActivity();
                }
                return ListView.separated(
                  itemCount: state.events.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return _buildEventListItem(event);
                  },
                );
              }
              return const SizedBox();
            },
          ),
        ),
      ],
    );
  }

  String _getEventLabel(String type) {
    switch (type.toLowerCase()) {
      case 'clock_in':
        return 'ASISTENCIA: ENTRADA';
      case 'clock_out':
        return 'ASISTENCIA: SALIDA';
      case 'login_success':
        return 'SEGURIDAD: ACCESO EXITOSO';
      case 'login_failed':
        return 'SEGURIDAD: INTENTO FALLIDO';
      case 'employee_created':
        return 'ADMIN: NUEVO EMPLEADO';
      case 'employee_updated':
        return 'ADMIN: EMPLEADO ACTUALIZADO';
      case 'employee_deleted':
        return 'ADMIN: EMPLEADO ELIMINADO';
      case 'shift_clock_in':
        return 'CAJA: APERTURA DE TURNO';
      case 'shift_clock_out':
        return 'CAJA: CIERRE DE TURNO';
      case 'break_start':
        return 'TURNO: INICIO DE DESCANSO';
      case 'break_end':
        return 'TURNO: FIN DE DESCANSO';
      default:
        return type.replaceAll('_', ' ').toUpperCase();
    }
  }

  Widget _buildEventListItem(AuditEventEntity event) {
    final isSelected = _selectedEvent?.id == event.id;
    final localTime = event.createdAt.toLocal();

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _onEventSelected(event),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? Colors.blue[300]! : Colors.grey[200]!,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              _buildEventIcon(event.eventType),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getEventLabel(event.eventType),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.blue[900] : const Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('dd MMM, hh:mm a').format(localTime),
                      style: TextStyle(fontSize: 12, color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey[300]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEventIcon(String type) {
    IconData iconData = Icons.info_outline;
    Color color = Colors.grey;

    if (type.contains('clock_in')) {
      iconData = Icons.login_rounded;
      color = Colors.blue;
    } else if (type.contains('clock_out')) {
      iconData = Icons.logout_rounded;
      color = Colors.orange;
    } else if (type.contains('break')) {
      iconData = Icons.coffee_rounded;
      color = Colors.brown;
    } else if (type.contains('inventory')) {
      iconData = Icons.inventory_2_outlined;
      color = Colors.green;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(iconData, size: 20, color: color),
    );
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

  Widget _buildEventDetailPanel() {
    if (_selectedEvent == null) return const SizedBox.shrink();

    final localTime = _selectedEvent!.createdAt.toLocal();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'DETALLE DE EVENTO',
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
                          _getEventLabel(_selectedEvent!.eventType),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A1A),
                            letterSpacing: -0.5,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Material(
                    color: Colors.grey[100],
                    shape: const CircleBorder(),
                    child: IconButton(
                      onPressed: () => setState(() => _selectedEvent = null),
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
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailItem(
                  Icons.calendar_today_outlined,
                  'Fecha',
                  DateFormat('dd MMMM, yyyy').format(localTime),
                ),
                const SizedBox(height: 24),
                _buildDetailItem(
                  Icons.access_time,
                  'Hora Exacta',
                  DateFormat('hh:mm:ss a').format(localTime),
                ),
                const SizedBox(height: 24),
                if (_selectedEvent!.employeeId != null)
                  _buildDetailItem(
                    Icons.person_outline,
                    'ID Empleado',
                    _selectedEvent!.employeeId!,
                  ),
                const SizedBox(height: 24),
                if (_selectedEvent!.metadata != null)
                  _buildDetailItem(
                    Icons.info_outline,
                    'Información Adicional',
                    _selectedEvent!.metadata!,
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[400]),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey[400],
                  letterSpacing: 1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAuditPanel() {
    if (_selectedEmployee == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header del Panel
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
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
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
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
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                        // Filtrar eventos SOLO del empleado seleccionado
                        final employeeEvents = state.events
                            .where((event) => event.employeeId == _selectedEmployee?.id)
                            .toList();

                        if (employeeEvents.isEmpty) {
                          return _buildNoActivity();
                        }
                        return ListView.separated(
                          itemCount: employeeEvents.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 16),
                          padding: const EdgeInsets.only(bottom: 32),
                          itemBuilder: (context, index) {
                            final event = employeeEvents[index];
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
    final localTime = event.createdAt.toLocal();
    final eventLabel = _getEventLabel(event.eventType);
    final isAttendance = event.eventType.contains('clock');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isAttendance ? Colors.blue[100]! : Colors.grey[200]!,
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
              color: isAttendance
                  ? Colors.blue[600]
                  : event.eventType.contains('shift')
                      ? Colors.orange[600]
                      : Colors.grey[600],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isAttendance
                  ? Icons.access_time_filled_rounded
                  : event.eventType.contains('security') || event.eventType.contains('login')
                      ? Icons.lock_outline_rounded
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
                  eventLabel,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isAttendance ? Colors.blue[900] : const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.access_time, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          DateFormat('hh:mm a').format(localTime), // Removed seconds for brevity
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        shape: BoxShape.circle,
                      ),
                    ),
                    Text(
                      DateFormat('dd MMM').format(localTime), // Shortened date
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
