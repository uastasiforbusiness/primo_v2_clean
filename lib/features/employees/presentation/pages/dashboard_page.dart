import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/core/presentation/widgets/app_scaffold.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../shifts/domain/entities/shift_entity.dart';
import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../shifts/presentation/bloc/shift_event.dart';
import '../../../shifts/presentation/bloc/shift_state.dart';

class DashboardPage extends StatelessWidget {
  final EmployeeEntity employee;

  const DashboardPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShiftBloc, ShiftState>(
      listener: (context, state) {
        if (state is ShiftError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        if (state is ShiftLoading) {
          return const AppScaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // El redirect de GoRouter se encarga de mandarnos a ClockInPage o BreakPage
        // si el estado no es ShiftActive. Aquí solo manejamos la vista del Dashboard.
        if (state is ShiftActive || state is ShiftOnBreak) {
          final shift = (state is ShiftActive) ? state.shift : (state as ShiftOnBreak).shift;
          final isBreak = state is ShiftOnBreak;

          return AppScaffold(
            appBar: AppBar(
              title: const Text('PRIMO V2 - Dashboard'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.lock_outline),
                  onPressed: () {
                    context.read<AuthBloc>().add(const LogoutRequested());
                  },
                  tooltip: 'Bloquear Pantalla',
                ),
              ],
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildUserCard(context, shift, isBreak),
                  const SizedBox(height: 24),
                  Expanded(
                    child: _buildActionGrid(context, shift, isBreak),
                  ),
                ],
              ),
            ),
          );
        }

        // Fallback por si el redirect tarda un frame
        return const AppScaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget _buildUserCard(BuildContext context, ShiftEntity shift, bool isBreak) {
    return Card(
      elevation: 4,
      color: isBreak ? Colors.orange[50] : null,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: isBreak ? Colors.orange : Colors.deepPurple,
                  child: Icon(
                    isBreak ? Icons.coffee : Icons.person,
                    size: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        employee.fullName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isBreak ? 'EN PAUSA' : employee.role.toValue(),
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: isBreak ? Colors.orange[800] : Colors.deepPurple,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            _buildInfoRow(
              context,
              'Turno Iniciado',
              _formatDateTime(shift.startedAt),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              context,
              'Fondo Inicial',
              shift.initialCash.toFormattedString(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionGrid(
    BuildContext context,
    ShiftEntity shift,
    bool isBreak,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: [
        if (!isBreak) ...[
          _buildActionCard(
            context,
            icon: Icons.coffee,
            title: 'Iniciar Pausa',
            color: Colors.orange,
            onTap: () => context.read<ShiftBloc>().add(StartBreakRequested(shift.id)),
          ),
          _buildActionCard(
            context,
            icon: Icons.shopping_cart,
            title: 'Ventas',
            color: Colors.green,
            onTap: () => context.pushNamed('active-shift'),
          ),
        ] else
          _buildActionCard(
            context,
            icon: Icons.play_arrow,
            title: 'Terminar Pausa',
            color: Colors.green,
            onTap: () => context.read<ShiftBloc>().add(EndBreakRequested(shift.id)),
          ),
        if (employee.role.canManageEmployees && !isBreak)
          _buildActionCard(
            context,
            icon: Icons.people,
            title: 'Empleados',
            color: Colors.blue,
            onTap: () => context.pushNamed('employees'),
          ),
        if (!isBreak)
          _buildActionCard(
            context,
            icon: Icons.logout,
            title: 'Cerrar Turno',
            color: Colors.red,
            onTap: () => _showClockOutDialog(context, shift.id),
          ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showClockOutDialog(BuildContext context, String shiftId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Cerrar Turno'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa el monto final en caja:'),
            const SizedBox(height: 16),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Monto Final',
                prefixText: '\$ ',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final finalCash = double.tryParse(controller.text) ?? 0.0;
              Navigator.of(dialogContext).pop();
              context.read<ShiftBloc>().add(
                    ClockOutRequested(shiftId: shiftId, finalCash: finalCash),
                  );
            },
            child: const Text('Cerrar Turno'),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
