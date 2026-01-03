import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_event.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';

class AppHeader extends StatefulWidget {
  final String title;

  const AppHeader({
    super.key,
    this.title = '',
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {
  late Stream<DateTime> _clockStream;

  @override
  void initState() {
    super.initState();
    _clockStream =
        Stream.periodic(const Duration(seconds: 1), (_) => DateTime.now()).asBroadcastStream();
  }

  @override
  Widget build(BuildContext context) {
    final displayTitle =
        widget.title.toUpperCase() == 'DASHBOARD' ? '' : widget.title.toUpperCase();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.transparent, // Revertidos a transparente como antes
      ),
      child: Row(
        children: [
          // Usuario e Info de Turno (AHORA A LA IZQUIERDA)
          _buildUserSection(context),

          const SizedBox(width: 32),

          // Título
          Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
              color: Colors.black45,
            ),
          ),

          const Spacer(),

          // Reloj (ESTILO ORIGINAL RESTAURADO)
          StreamBuilder<DateTime>(
            stream: _clockStream,
            initialData: DateTime.now(),
            builder: (context, snapshot) {
              final now = snapshot.data!;
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        DateFormat('EEEE').format(now).toUpperCase(),
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[700],
                          letterSpacing: 0.5,
                        ),
                      ),
                      Text(
                        DateFormat('dd MMM').format(now),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black45,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Text(
                    DateFormat('hh:mm').format(now),
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat('a').format(now),
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[900],
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
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

            final bool isActive = shiftState is ShiftActive;
            final bool isOnBreak = shiftState is ShiftOnBreak;
            final bool hasShift = isActive || isOnBreak;
            final bool hasLaborShift =
                authState is AuthAuthenticated && authState.workShift != null;
            final bool isMenuEnabled = hasShift || hasLaborShift;
            final shift = isActive ? shiftState.shift : (isOnBreak ? shiftState.shift : null);

            return PopupMenuButton<String>(
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              position: PopupMenuPosition.under,
              enabled: isMenuEnabled,
              onSelected: (value) {
                if (value == 'pause' && isActive) {
                  context.read<ShiftBloc>().add(StartBreakRequested(shift!.id));
                } else if (value == 'clock_out' && isActive) {
                  _showClockOutDialog(context, shift!.id);
                }
              },
              itemBuilder: (context) => [
                if (authState is AuthAuthenticated && authState.workShift != null)
                  PopupMenuItem(
                    enabled: false,
                    child: Container(
                      width: 200,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'ESTADO DE TURNO',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w900,
                                color: Colors.black87,
                                letterSpacing: 1.1,
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          _buildInfoRow(
                            Icons.calendar_today_rounded,
                            'Entrada:',
                            _formatDateTime(authState.workShift!.clockIn),
                            context,
                          ),
                          const SizedBox(height: 4),
                          StreamBuilder<DateTime>(
                            stream: _clockStream,
                            builder: (context, snapshot) {
                              final clockIn = authState.workShift!.clockIn;
                              final now = snapshot.data ?? DateTime.now();
                              final diff = now.difference(clockIn);
                              return _buildInfoRow(
                                Icons.timer_outlined,
                                'Tiempo:',
                                '${diff.inHours}h ${diff.inMinutes.remainder(60)}m',
                                context,
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                const PopupMenuDivider(),
                if (isActive)
                  PopupMenuItem(
                    value: 'pause',
                    child: _buildPopupItem(Icons.coffee_rounded, 'Iniciar Pausa', Colors.blue),
                  ),
                if (isActive)
                  PopupMenuItem(
                    value: 'clock_out',
                    child: _buildPopupItem(Icons.logout_rounded, 'Cerrar Turno', Colors.red),
                  ),
              ],
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: hasShift ? Colors.blue.withAlpha(20) : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.blue[50],
                      child: Text(
                        name[0],
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'ID: #$id',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey[500],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    if (hasShift) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.grey),
                    ],
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPopupItem(IconData icon, String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 12),
          Text(
            label,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: color),
          ),
        ],
      ),
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
              context
                  .read<ShiftBloc>()
                  .add(ClockOutRequested(shiftId: shiftId, finalCash: finalCash));
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
        Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.black87)),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}
