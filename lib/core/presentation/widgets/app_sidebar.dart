import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_event.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_event.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final String routeName;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', routeName: 'dashboard'),
      SidebarItem(icon: Icons.shopping_cart_outlined, label: 'Venta', routeName: 'active-shift'),
      SidebarItem(icon: Icons.inventory_2_outlined, label: 'Inventario', routeName: 'inventory'),
      SidebarItem(icon: Icons.people_outline, label: 'Empleados', routeName: 'employees'),
      SidebarItem(icon: Icons.assignment_outlined, label: 'Auditoría', routeName: 'audit'),
      SidebarItem(icon: Icons.bar_chart_outlined, label: 'Reportes', routeName: 'reports'),
    ];

    return Container(
      width: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(4, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 8),
          const Divider(height: 1, indent: 24, endIndent: 24),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                // Caso especial para el dashboard base
                final bool active = item.routeName == 'dashboard'
                    ? (currentRoute == '/dashboard')
                    : currentRoute.contains(item.routeName);

                return _buildSidebarItem(context, item, active);
              },
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocBuilder<ShiftBloc, ShiftState>(
          builder: (context, shiftState) {
            String name = 'Usuario';
            String id = '001';

            if (authState is AuthAuthenticated) {
              name = authState.employee.fullName;
              id = authState.employee.id.substring(0, 3).toUpperCase();
            }

            final bool canShowShiftActions = shiftState is ShiftActive;

            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 40, 16, 24),
              child: PopupMenuButton<String>(
                offset: const Offset(0, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                position: PopupMenuPosition.under,
                enabled: canShowShiftActions,
                onSelected: (value) {
                  if (value == 'pause') {
                    final shiftId = (shiftState as ShiftActive).shift.id;
                    context.read<ShiftBloc>().add(StartBreakRequested(shiftId));
                  } else if (value == 'clock_out') {
                    final shiftId = (shiftState as ShiftActive).shift.id;
                    _showClockOutDialog(context, shiftId);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    enabled: false,
                    child: Container(
                      width: 200, // Forzar un ancho mínimo mayor
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'ESTADO DEL TURNO',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildInfoRow(
                            Icons.access_time_rounded,
                            'Iniciado:',
                            _formatDateTime((shiftState as ShiftActive).shift.startedAt),
                            context,
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.payments_outlined,
                            'Base:',
                            (shiftState).shift.initialCash.toFormattedString(),
                            context,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'pause',
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.coffee_rounded,
                            color: Theme.of(context).colorScheme.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          const Text(
                            'Iniciar Pausa',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'clock_out',
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.logout_rounded,
                            color: Colors.red,
                            size: 24,
                          ),
                          SizedBox(width: 16),
                          Text(
                            'Cerrar Turno',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.transparent,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.blue.withOpacity(0.2), width: 2),
                        ),
                        child: CircleAvatar(
                          radius: 22,
                          backgroundColor: Colors.blue[50],
                          child: Text(
                            name[0],
                            style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                if (canShowShiftActions)
                                  const Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 18,
                                    color: Colors.grey,
                                  ),
                              ],
                            ),
                            Text(
                              'Cashier ID: #$id',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[500],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showClockOutDialog(BuildContext context, String shiftId) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Cerrar Turno'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Ingresa el monto final en caja para finalizar:'),
            const SizedBox(height: 24),
            TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              autofocus: true,
              decoration: InputDecoration(
                labelText: 'Monto Final',
                prefixText: '\$ ',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[50],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text('CANCELAR', style: TextStyle(color: Colors.grey[600])),
          ),
          ElevatedButton(
            onPressed: () {
              final finalCash = double.tryParse(controller.text) ?? 0.0;
              Navigator.of(dialogContext).pop();
              context.read<ShiftBloc>().add(
                    ClockOutRequested(shiftId: shiftId, finalCash: finalCash),
                  );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('CERRAR TURNO'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 16),
        Text(
          label,
          style: const TextStyle(fontSize: 15, color: Colors.black87),
        ),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _buildSidebarItem(BuildContext context, SidebarItem item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.goNamed(item.routeName),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withOpacity(0.08) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  size: 22,
                  color: isSelected ? Colors.blue[700] : Colors.grey[500],
                ),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.blue[700] : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          const Divider(height: 1, indent: 8, endIndent: 8),
          const SizedBox(height: 8),
          _buildSidebarItem(
            context,
            SidebarItem(
              icon: Icons.settings_outlined,
              label: 'Configuraciones',
              routeName: 'settings',
            ),
            currentRoute.contains('settings'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: InkWell(
              onTap: () {
                context.read<AuthBloc>().add(const LogoutRequested());
              },
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 22, color: Colors.redAccent),
                    const SizedBox(width: 16),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
