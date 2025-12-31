import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../di/injection_container.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';
import '../../../../core/shared_kernel/role.dart';
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
      backgroundColor: Colors.grey[100]?.withAlpha(200),
      body: Row(
        children: [
          // Pantalla Principal
          Expanded(
            flex: 5,
            child: Column(
              children: [
                _buildTopBar(),
                _buildContextualActions(),
                Expanded(child: _buildEmployeeGrid()),
              ],
            ),
          ),

          // Panel de Detalles
          if (_showDetails && _selectedEmployee != null) ...[
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              flex: 2,
              child: _buildEmployeeDetails(_selectedEmployee!),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTopBar() {
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
                      color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
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
                style:
                    TextStyle(color: Colors.grey[600], fontWeight: FontWeight.w600, fontSize: 14),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildContextualActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Row(
        children: [
          _buildActionButton(
              label: 'Nuevo', icon: Icons.person_add_outlined, onTap: () => _showEmployeeDialog()),
          const SizedBox(width: 12),
          _buildActionButton(label: 'Exportar', icon: Icons.file_download_outlined, onTap: () {}),
          const SizedBox(width: 12),
          _buildActionButton(
              label: 'Roles', icon: Icons.admin_panel_settings_outlined, onTap: () {}),
          const SizedBox(width: 12),
          _buildActionButton(
              label: 'Asistencia', icon: Icons.calendar_today_outlined, onTap: () {}),
        ],
      ),
    );
  }

  Widget _buildActionButton(
      {required String label, required IconData icon, required VoidCallback onTap}) {
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
                  color: Colors.black.withAlpha(5), blurRadius: 10, offset: const Offset(0, 4)),
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
                      fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmployeeGrid() {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) return const Center(child: CircularProgressIndicator());
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
            itemBuilder: (context, index) => _buildEmployeeCard(employees[index]),
          );
        }
        return const Center(child: Text('No se encontraron empleados'));
      },
    );
  }

  Widget _buildEmployeeCard(EmployeeEntity employee) {
    final isSelected = _selectedEmployee?.id == employee.id;
    final roleColor = _getRoleColor(employee.role);

    return InkWell(
      onTap: () => setState(() {
        _selectedEmployee = employee;
        _showDetails = true;
      }),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.blue, width: 2) : null,
          boxShadow: [
            BoxShadow(color: Colors.black.withAlpha(5), blurRadius: 15, offset: const Offset(0, 8)),
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
                  child: Text(employee.name[0],
                      style: TextStyle(color: roleColor, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(employee.fullName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis),
                      Text(employee.role.toValue(),
                          style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
        Text(label,
            style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold)),
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
              const Text('Detalles', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => setState(() => _showDetails = false)),
            ],
          ),
          const SizedBox(height: 24),
          Center(
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.blue[50],
              child: Text(employee.name[0],
                  style: const TextStyle(
                      fontSize: 32, color: Colors.blue, fontWeight: FontWeight.bold)),
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Column(
              children: [
                Text(employee.fullName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Text(employee.role.toValue().toUpperCase(),
                    style: TextStyle(
                        color: Colors.blue[700],
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildDetailEntry(Icons.badge_outlined, 'ID', employee.id),
          _buildDetailEntry(Icons.email_outlined, 'Email', 'No disponible'),
          _buildDetailEntry(Icons.phone_outlined, 'Teléfono', 'No disponible'),
          const Spacer(),
          Column(
            children: [
              _buildWideButton(label: 'Editar', icon: Icons.edit_outlined, isPrimary: false),
              const SizedBox(height: 12),
              _buildWideButton(
                  label: 'Eliminar',
                  icon: Icons.delete_outline,
                  isPrimary: true,
                  isDestructive: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailEntry(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration:
                BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, size: 18, color: Colors.grey[600]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 11)),
                Text(value,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWideButton(
      {required String label,
      required IconData icon,
      bool isPrimary = true,
      bool isDestructive = false}) {
    final style = isPrimary
        ? ElevatedButton.styleFrom(
            backgroundColor: isDestructive ? Colors.red[50] : Colors.blue[50],
            foregroundColor: isDestructive ? Colors.red : Colors.blue,
            elevation: 0,
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          )
        : OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          );

    final child = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [Icon(icon, size: 18), const SizedBox(width: 8), Text(label)],
    );

    return SizedBox(
      width: double.infinity,
      child: isPrimary
          ? ElevatedButton(onPressed: () {}, style: style, child: child)
          : OutlinedButton(onPressed: () {}, style: style, child: child),
    );
  }

  Color _getRoleColor(Role role) {
    switch (role) {
      case Role.admin:
        return Colors.purple;
      case Role.supervisor:
        return Colors.blue;
      case Role.staff:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _showEmployeeDialog() async {
    await showDialog(
      context: context,
      builder: (dialogContext) => EmployeeFormDialog(
        onSave: (employee, pin) {
          context
              .read<EmployeeBloc>()
              .add(employee_event.CreateEmployeeRequested(employee: employee, pin: pin!));
        },
      ),
    );
  }
}
