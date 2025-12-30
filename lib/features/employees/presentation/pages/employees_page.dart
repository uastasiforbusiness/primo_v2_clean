import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/core/presentation/widgets/app_scaffold.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';

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

class _EmployeesView extends StatefulWidget {
  const _EmployeesView();

  @override
  State<_EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<_EmployeesView> {
  EmployeeEntity? _selectedEmployee;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Stack(
        children: [
          // Logo de fondo centrado
          Center(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/background.png',
                width: MediaQuery.of(context).size.width * 0.4,
              ),
            ),
          ),
          Row(
            children: [
              // Columna Central (Principal)
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    _buildTopBar(context),
                    _buildContextualActions(context),
                    Expanded(
                      child: _buildEmployeeGrid(context),
                    ),
                  ],
                ),
              ),

              // Columna Derecha (Deslizable) - Usando flex 1 para consistencia con ActiveShiftPage
              if (_showDetails && _selectedEmployee != null) ...[
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  flex: 1,
                  child: _buildEmployeeDetails(_selectedEmployee!),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Buscar empleados por nombre, rol o ID...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          StreamBuilder(
            stream: Stream.periodic(const Duration(seconds: 1)),
            builder: (context, snapshot) {
              return Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContextualActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          _buildContextualButton(
            label: 'Nuevo',
            icon: Icons.person_add_outlined,
            onTap: () => _showEmployeeDialog(context),
          ),
          const SizedBox(width: 12),
          _buildContextualButton(
            label: 'Exportar',
            icon: Icons.file_download_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildContextualButton(
            label: 'Roles',
            icon: Icons.admin_panel_settings_outlined,
            onTap: () {},
          ),
          const SizedBox(width: 12),
          _buildContextualButton(
            label: 'Asistencia',
            icon: Icons.calendar_today_outlined,
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildContextualButton({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 18, color: Colors.black87),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold, 
                    color: Colors.black87,
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeGrid(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeLoaded) {
          final employees = state.employees;
          return GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 200,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: employees.length,
            itemBuilder: (context, index) {
              return _buildEmployeeCard(context, employees[index]);
            },
          );
        }

        return const Center(child: Text('No se encontraron empleados'));
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeEntity employee) {
    final isSelected = _selectedEmployee?.id == employee.id;
    final roleColor = _getRoleColor(employee.role);

    return InkWell(
      onTap: () {
        setState(() {
          _selectedEmployee = employee;
          _showDetails = true;
        });
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: roleColor.withAlpha(30),
                  child: Text(
                    employee.name[0],
                    style: TextStyle(color: roleColor, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSmallStat('ID', '#${employee.id.substring(0, 4)}'),
                _buildSmallStat('Estado', 'Activo'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
      ],
    );
  }

  Widget _buildEmployeeDetails(EmployeeEntity employee) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Detalles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => setState(() => _showDetails = false),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[50],
              child: Text(
                employee.name[0],
                style: const TextStyle(fontSize: 32, color: Colors.blue, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(
                  employee.fullName,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                Text(
                  employee.role.toValue().toUpperCase(),
                  style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold, letterSpacing: 1.2, fontSize: 12),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildDetailItem(Icons.badge_outlined, 'ID', employee.id),
          _buildDetailItem(Icons.email_outlined, 'Email', 'No disponible'),
          _buildDetailItem(Icons.phone_outlined, 'Teléfono', 'No disponible'),
          const Spacer(),
          Column(
            children: [
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit_outlined, size: 18),
                  label: const Text('Editar'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.delete_outline, size: 18),
                  label: const Text('Eliminar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[50],
                    foregroundColor: Colors.red,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getRoleColor(Role role) {
    if (role == Role.admin) return Colors.purple;
    if (role == Role.supervisor) return Colors.blue;
    if (role == Role.staff) return Colors.green;
    return Colors.grey;
  }

  Future<void> _showEmployeeDialog(BuildContext parentContext) async {
    await showDialog(
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
