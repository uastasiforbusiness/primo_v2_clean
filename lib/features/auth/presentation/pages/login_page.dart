import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../di/injection_container.dart';
import '../../../employees/presentation/pages/dashboard_page.dart';
import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../shifts/presentation/bloc/shift_event.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/numpad_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _pin = '';
  int _failedAttempts = 0;
  bool _isLocked = false;

  void _onNumberPressed(String number) {
    if (_isLocked) return;

    setState(() {
      if (_pin.length < 4) {
        _pin += number;
      }

      if (_pin.length == 4) {
        context.read<AuthBloc>().add(LoginWithPinRequested(_pin));
      }
    });
  }

  void _onBackspacePressed() {
    if (_isLocked) return;

    setState(() {
      if (_pin.isNotEmpty) {
        _pin = _pin.substring(0, _pin.length - 1);
      }
    });
  }

  void _onClearPressed() {
    if (_isLocked) return;

    setState(() {
      _pin = '';
    });
  }

  void _handleLoginError() {
    setState(() {
      _failedAttempts++;
      _pin = '';

      if (_failedAttempts >= 3) {
        _isLocked = true;
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted) {
            setState(() {
              _isLocked = false;
              _failedAttempts = 0;
            });
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (context) =>
                      sl<ShiftBloc>()..add(LoadActiveShift(state.employee.id)),
                  child: DashboardPage(employee: state.employee),
                ),
              ),
            );
          } else if (state is AuthError) {
            _handleLoginError();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.point_of_sale_rounded,
                      size: 80, color: Colors.deepPurple),
                  const SizedBox(height: 16),
                  Text(
                    'PRIMO V2',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sistema POS',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 48),
                  if (_isLocked)
                    Column(
                      children: [
                        const Icon(Icons.lock_outline,
                            size: 48, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          'Bloqueado temporalmente',
                          style: TextStyle(
                            color: Colors.red[700],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      children: [
                        Text(
                          'Ingresa tu PIN',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Container(
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: index < _pin.length
                                    ? Colors.deepPurple
                                    : Colors.grey[300],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 32),
                        NumpadWidget(
                          onNumberPressed: _onNumberPressed,
                          onBackspacePressed: _onBackspacePressed,
                          onClearPressed: _onClearPressed,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
