import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo_v2/di/injection_container.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/features/auth/presentation/pages/login_page.dart';
import 'package:primo_v2/features/splash/presentation/pages/splash_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/dashboard_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/employees_page.dart';
import 'package:primo_v2/features/auth/presentation/pages/clock_in_page.dart';
import 'package:primo_v2/features/shifts/presentation/pages/active_shift_page.dart';
import 'package:primo_v2/features/shifts/presentation/pages/break_page.dart';
import 'package:primo_v2/features/error/presentation/pages/error_page.dart';
import 'package:primo_v2/features/error/presentation/pages/forbidden_page.dart';

/// AppRouter - Centralized navigation for PRIMO V2
class AppRouter {
  static final AppRouter _instance = AppRouter._internal();
  static AppRouter get instance => _instance;

  AppRouter._internal();

  static GoRouter get router => _instance._router;

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    
    // Escucha cambios tanto en Auth como en Shifts para reaccionar a cambios de estado
    refreshListenable: MultiSourceRefreshListenable([
      sl<AuthBloc>().stream,
      sl<ShiftBloc>().stream,
    ]),

    routes: [
      /// Public routes
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/error',
        name: 'error',
        builder: (context, state) => const ErrorPage(),
      ),
      GoRoute(
        path: '/forbidden',
        name: 'forbidden',
        builder: (context, state) => const ForbiddenPage(),
      ),

      /// Protected routes (Dashboard Area)
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthAuthenticated) {
            return DashboardPage(employee: authState.employee);
          }
          return const LoginPage();
        },
        routes: [
          GoRoute(
            path: 'clock-in',
            name: 'clock-in',
            builder: (context, state) {
              final authState = context.read<AuthBloc>().state;
              if (authState is AuthAuthenticated) {
                return ClockInPage(employee: authState.employee);
              }
              return const LoginPage();
            },
          ),
          GoRoute(
            path: 'active-shift',
            name: 'active-shift',
            builder: (context, state) => const ActiveShiftPage(),
          ),
          GoRoute(
            path: 'break',
            name: 'break',
            builder: (context, state) => const BreakPage(),
          ),
          GoRoute(
            path: 'employees',
            name: 'employees',
            builder: (context, state) => const EmployeesPage(),
          ),
          GoRoute(
            path: 'settings',
            name: 'settings',
            builder: (context, state) => const Scaffold(
              body: Center(child: Text('Settings Page - TODO')),
            ),
          ),
        ],
      ),
    ],

    /// Redirect logic
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final shiftState = context.read<ShiftBloc>().state;

      final bool loggingIn = state.matchedLocation == '/login';
      final bool inSplash = state.matchedLocation == '/';

      // 1. Manejo de Autenticación
      if (authState is! AuthAuthenticated) {
        if (loggingIn || inSplash) return null;
        return '/login';
      }

      // 2. Si está autenticado y en login/splash, ir al dashboard
      if (loggingIn || inSplash) {
        return '/dashboard';
      }

      // 3. Lógica de Turnos (Solo si está en el área de dashboard)
      if (state.matchedLocation.startsWith('/dashboard')) {
        // Si el turno está inactivo, forzar clock-in (a menos que ya esté ahí)
        if (shiftState is ShiftInactive && state.matchedLocation != '/dashboard/clock-in') {
          return '/dashboard/clock-in';
        }

        // Si el turno está activo y está en clock-in, mandar al dashboard principal
        if (shiftState is ShiftActive && state.matchedLocation == '/dashboard/clock-in') {
          return '/dashboard';
        }

        // Si está en break, forzar break page
        if (shiftState is ShiftOnBreak && state.matchedLocation != '/dashboard/break') {
          return '/dashboard/break';
        }
        
        // Si NO está en break pero intenta entrar a la página de break, volver al dashboard
        if (shiftState is! ShiftOnBreak && state.matchedLocation == '/dashboard/break') {
          return '/dashboard';
        }
      }

      // 4. Protección de Rutas Admin
      if (state.matchedLocation.contains('/employees') || state.matchedLocation.contains('/settings')) {
        if (authState.employee.role != Role.admin) {
          return '/forbidden';
        }
      }

      return null;
    },

    errorBuilder: (context, state) => ErrorPage(
      message: state.error?.toString() ?? 'Error de navegación',
    ),
  );
}

/// Utility class to bridge multiple Streams -> Listenable for GoRouter
class MultiSourceRefreshListenable extends ChangeNotifier {
  MultiSourceRefreshListenable(List<Stream<dynamic>> streams) {
    for (final stream in streams) {
      _subscriptions.add(
        stream.asBroadcastStream().listen((_) => notifyListeners()),
      );
    }
  }

  final List<StreamSubscription<dynamic>> _subscriptions = [];

  @override
  void dispose() {
    for (final sub in _subscriptions) {
      sub.cancel();
    }
    super.dispose();
  }
}
