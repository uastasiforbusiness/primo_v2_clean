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
// Nuevos imports para las páginas de error
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
    
    // Escucha activa del AuthBloc
    refreshListenable: GoRouterRefreshStream(sl<AuthBloc>().stream),
    
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
        builder: (context, state) {
          // CORRECCIÓN: Extraer el mensaje si existe, o usar uno por defecto
          final message = state.extra as String? ?? 'Ocurrió un error inesperado';
          return ErrorPage(message: message);
        },
      ),
      GoRoute(
        path: '/forbidden',
        name: 'forbidden',
        builder: (context, state) => const ForbiddenPage(),
      ),

      /// Protected routes
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
      ),
      GoRoute(
        path: '/dashboard/clock-in',
        name: 'clock-in',
        builder: (context, state) {
           final authState = context.read<AuthBloc>().state;
           if (authState is AuthAuthenticated) return ClockInPage(employee: authState.employee);
           return const LoginPage();
        },
      ),
      GoRoute(
        path: '/dashboard/active-shift',
        name: 'active-shift',
        builder: (context, state) => const ActiveShiftPage(),
      ),
      GoRoute(
        path: '/dashboard/break',
        name: 'break',
        builder: (context, state) => const BreakPage(),
      ),

      /// Admin routes
      GoRoute(
        path: '/dashboard/employees',
        name: 'employees',
        builder: (context, state) => const EmployeesPage(),
      ),
      GoRoute(
        path: '/dashboard/settings',
        name: 'settings',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Settings Page - TODO')),
        ),
      ),
    ],

    /// Redirect logic
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final shiftBloc = context.read<ShiftBloc>();
      
      final authState = authBloc.state;
      final shiftState = shiftBloc.state;

      // 1. Guard de Autenticación
      final isAuthenticated = authState is AuthAuthenticated;
      final isGoingToLogin = state.matchedLocation == '/login';

      if (!isAuthenticated) {
        if (state.matchedLocation == '/' ||
            state.matchedLocation == '/error' ||
            state.matchedLocation == '/forbidden') {
          return null;
        }
        return '/login';
      }

      // 2. Si está autenticado y va al login -> Dashboard
      if (isAuthenticated && isGoingToLogin) {
        return '/dashboard';
      }

      // 3. Lógica de Turnos (SHIFTS)
      if (shiftState is ShiftInactive &&
          !state.matchedLocation.contains('/dashboard/clock-in')) {
        return '/dashboard/clock-in';
      }

      if (shiftState is ShiftActive &&
          state.matchedLocation.contains('/clock-in')) {
        return '/dashboard/active-shift';
      }

      if (shiftState is ShiftOnBreak &&
          state.matchedLocation != '/dashboard/break') {
        return '/dashboard/break';
      }

      // 4. Roles (Solo Admin)
      if (state.matchedLocation.contains('/employees') ||
          state.matchedLocation.contains('/settings')) {
        if (authState is AuthAuthenticated && authState.employee.role != Role.admin) {
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

/// Utility class to bridge Stream -> Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
