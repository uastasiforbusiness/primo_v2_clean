import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo_v2/features/shifts/domain/entities/shift_entity.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';

/// ActiveShiftPage - Main operations screen during active shift
class ActiveShiftPage extends StatelessWidget {
  const ActiveShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Turno Activo'),
        actions: [
          IconButton(
            icon: const Icon(Icons.coffee),
            onPressed: () {
              // TODO: Get current shift ID and start break
              // context.read<ShiftBloc>().add(StartBreakRequested(shiftId));
            },
            tooltip: 'Iniciar Pausa',
          ),
        ],
      ),
      body: BlocBuilder<ShiftBloc, ShiftState>(
        builder: (context, state) {
          if (state is ShiftActive) {
            return _buildActiveShiftContent(context, state.shift);
          }

          if (state is ShiftLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return const Center(
            child: Text('Cargando información del turno...'),
          );
        },
      ),
    );
  }

  Widget _buildActiveShiftContent(BuildContext context, ShiftEntity shift) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Shift info card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  _buildInfoRow(
                      context, 'Iniciado', _formatTime(shift.startedAt)),
                  const Divider(),
                  _buildInfoRow(context, 'Fondo Inicial',
                      shift.initialCash.toFormattedString()),
                  const Divider(),
                  _buildInfoRow(
                      context, 'Duración', _formatDuration(shift.startedAt)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Action buttons
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildActionButton(
                  context,
                  icon: Icons.shopping_cart,
                  label: 'Ventas',
                  color: Colors.green,
                  onPressed: () {
                    // TODO: Navigate to sales
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.people,
                  label: 'Clientes',
                  color: Colors.blue,
                  onPressed: () {
                    // TODO: Navigate to customers
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.receipt,
                  label: 'Reportes',
                  color: Colors.purple,
                  onPressed: () {
                    // TODO: Navigate to reports
                  },
                ),
                _buildActionButton(
                  context,
                  icon: Icons.logout,
                  label: 'Cerrar Turno',
                  color: Colors.red,
                  onPressed: () {
                    // TODO: Show clock-out dialog
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(24),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 32, color: Colors.white),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(DateTime startedAt) {
    final duration = DateTime.now().difference(startedAt);
    return '${duration.inHours}h ${duration.inMinutes.remainder(60)}m';
  }
}
