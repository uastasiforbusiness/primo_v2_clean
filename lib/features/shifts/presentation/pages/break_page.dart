import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/core/presentation/widgets/app_scaffold.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_event.dart';
import '../bloc/shift_bloc.dart';
import '../bloc/shift_event.dart';
import '../bloc/shift_state.dart';

/// BreakPage - Screen shown during employee break
class BreakPage extends StatelessWidget {
  const BreakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ShiftBloc, ShiftState>(
      listener: (context, state) {
        if (state is ShiftActive) {
          // Si el turno vuelve a estar activo, regresamos al dashboard
          context.goNamed('dashboard');
        } else if (state is ShiftError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: AppScaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 80),

                  // Status Text
                  Text(
                    'PAUSA ACTIVA',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                          letterSpacing: 4,
                        ),
                  ),
                  const SizedBox(height: 16),

                  // Message
                  Text(
                    'Tu turno se encuentra suspendido temporalmente.\nPresiona el botón para reanudar tus actividades.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[700],
                        ),
                  ),
                  const SizedBox(height: 48),

                  // Timer
                  const BreakTimer(),
                  const SizedBox(height: 48),

                  // Action Buttons
                  _buildActionButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        _buildResumeButton(context),
        const SizedBox(height: 16),
        _buildLogoutButton(context),
      ],
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return TextButton.icon(
      onPressed: () {
        // Al cerrar sesión, el middleware de GoRouter nos llevará a /login
        context.read<AuthBloc>().add(const LogoutRequested());
      },
      icon: const Icon(Icons.logout, color: Colors.grey),
      label: Text(
        'SALIR',
        style: TextStyle(
          color: Colors.grey[600],
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }

  Widget _buildResumeButton(BuildContext context) {
    return BlocBuilder<ShiftBloc, ShiftState>(
      builder: (context, state) {
        final isLoading = state is ShiftLoading;
        final shiftId = state is ShiftOnBreak ? state.shift.id : '';

        return SizedBox(
          width: 280,
          height: 60,
          child: ElevatedButton(
            onPressed: isLoading || shiftId.isEmpty
                ? null
                : () {
                    context.read<ShiftBloc>().add(EndBreakRequested(shiftId));
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[600],
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: Colors.green.withAlpha(102), // ~0.4
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow_rounded, size: 28),
                      SizedBox(width: 12),
                      Text(
                        'REANUDAR TURNO',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

/// BreakTimer - Shows elapsed break time
class BreakTimer extends StatefulWidget {
  const BreakTimer({super.key});

  @override
  State<BreakTimer> createState() => _BreakTimerState();
}

class _BreakTimerState extends State<BreakTimer> {
  late DateTime _startTime;
  String _formattedTime = '00:00';
  bool _isRunning = true;

  @override
  void initState() {
    super.initState();
    _startTime = DateTime.now();
    _startTimer();
  }

  void _startTimer() {
    if (!_isRunning) return;

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted && _isRunning) {
        setState(() {
          final duration = DateTime.now().difference(_startTime);
          final minutes = duration.inMinutes.toString().padLeft(2, '0');
          final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
          _formattedTime = '$minutes:$seconds';
        });
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    _isRunning = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'TIEMPO TRANSCURRIDO',
          style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: Colors.grey[600],
                letterSpacing: 1.5,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white.withAlpha(128), // ~0.5
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha(51)), // ~0.2
          ),
          child: Text(
            _formattedTime,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    );
  }
}
