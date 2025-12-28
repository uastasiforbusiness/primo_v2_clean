import 'package:flutter/material.dart';
// TODO: Uncomment when implementing EndBreakRequested functionality
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';

/// BreakPage - Screen shown during employee break
class BreakPage extends StatelessWidget {
  const BreakPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('En Pausa'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Break icon
              Icon(
                Icons.coffee,
                size: 100,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 32),

              // Status
              Text(
                'PAUSA ACTIVA',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
              ),
              const SizedBox(height: 16),

              // Message
              Text(
                'Tu turno está en pausa. Presiona el botón para reanudar.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 48),

              // Resume button
              ElevatedButton.icon(
                onPressed: () {
                  // TODO: Get current shift ID and end break
                  // context.read<ShiftBloc>().add(EndBreakRequested(shiftId));
                },
                icon: const Icon(Icons.play_arrow, size: 24),
                label: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text(
                    'REAUDAR TURNO',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Timer
              const BreakTimer(),
            ],
          ),
        ),
      ),
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
  DateTime _startTime = DateTime.now();
  String _formattedTime = '00:00';

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          final duration = DateTime.now().difference(_startTime);
          _formattedTime = '${duration.inMinutes.toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
        });
        _startTimer();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Tiempo en pausa',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
        ),
        const SizedBox(height: 4),
        Text(
          _formattedTime,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}