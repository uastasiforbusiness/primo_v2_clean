import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/presentation/widgets/app_scaffold.dart';
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
      if (_pin.length < 4) _pin += number;
      if (_pin.length == 4) context.read<AuthBloc>().add(LoginWithPinRequested(_pin));
    });
  }

  void _onBackspacePressed() {
    if (_isLocked) return;
    setState(() {
      if (_pin.isNotEmpty) _pin = _pin.substring(0, _pin.length - 1);
    });
  }

  void _onClearPressed() {
    if (_isLocked) return;
    setState(() => _pin = '');
  }

  void _handleLoginError() {
    setState(() {
      _failedAttempts++;
      _pin = '';
      if (_failedAttempts >= 3) {
        _isLocked = true;
        Future.delayed(const Duration(seconds: 30), () {
          if (mounted)
            setState(() {
              _isLocked = false;
              _failedAttempts = 0;
            });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: _onAuthStateChanged,
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            return Stack(
              children: [
                _buildLoginContent(isLoading),
                if (isLoading) _buildLoadingOverlay(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onAuthStateChanged(BuildContext context, AuthState state) {
    if (state is AuthAuthenticated) {
      if (mounted) context.read<ShiftBloc>().add(LoadActiveShift(state.employee.id));
    } else if (state is AuthError) {
      _handleLoginError();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildLoginContent(bool isLoading) {
    return SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Espacio para logo
              const SizedBox(height: 48),
              if (_isLocked) _buildLockedState() else _buildNumpadState(isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLockedState() {
    return Column(
      children: [
        const Icon(Icons.lock_outline, size: 48, color: Colors.red),
        const SizedBox(height: 16),
        Text(
          'Bloqueado temporalmente',
          style: TextStyle(color: Colors.red[700], fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildNumpadState(bool isLoading) {
    return Column(
      children: [
        Text('Ingresa tu PIN', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 24),
        _buildPinIndicators(),
        const SizedBox(height: 32),
        IgnorePointer(
          ignoring: isLoading,
          child: Opacity(
            opacity: isLoading ? 0.5 : 1.0,
            child: NumpadWidget(
              onNumberPressed: _onNumberPressed,
              onBackspacePressed: _onBackspacePressed,
              onClearPressed: _onClearPressed,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPinIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        4,
        (index) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < _pin.length ? Colors.deepPurple : Colors.grey[300],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withAlpha(77),
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
