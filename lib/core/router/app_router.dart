import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/core/shared_ui/main_layout.dart';
import 'package:primo_v2/di/injection_container.dart';
import 'package:primo_v2/features/audit/presentation/pages/audit_page.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/auth/presentation/pages/clock_in_page.dart';
import 'package:primo_v2/features/auth/presentation/pages/labor_clock_in_page.dart';
import 'package:primo_v2/features/auth/presentation/pages/login_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/dashboard_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/employees_page.dart';
// Nuevos imports para las páginas de error
import 'package:primo_v2/features/error/presentation/pages/error_page.dart';
import 'package:primo_v2/features/error/presentation/pages/forbidden_page.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';
import 'package:primo_v2/features/shifts/presentation/pages/active_shift_page.dart';
import 'package:primo_v2/features/shifts/presentation/pages/break_page.dart';
import 'package:primo_v2/features/splash/presentation/pages/splash_page.dart';

/// AppRouter - Centralized navigation for PRIMO V2
class AppRouter {
  static final AppRouter _instance = AppRouter._internal();
  static AppRouter get instance => _instance;

  AppRouter._internal();

  static GoRouter get router => _instance._router;

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,

    // Escucha activa de AuthBloc para refrescar navegación
    // ShiftBloc se manejará de forma reactiva en la lógica de redirección
    refreshListenable: GoRouterRefreshStream([
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
      GoRoute(
        path: '/labor-clock-in',
        name: 'labor-clock-in',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is AuthClockInRequired) {
            return LaborClockInPage(employee: authState.employee);
          }
          return const LoginPage();
        },
      ),

      /// Protected routes with Sidebar
      ShellRoute(
        builder: (context, state, child) {
          return MainLayout(
            currentRoute: state.matchedLocation,
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            pageBuilder: (context, state) {
              final authState = context.read<AuthBloc>().state;
              return NoTransitionPage(
                key: const ValueKey('dashboard-page'),
                child: DashboardPage(employee: (authState as AuthAuthenticated).employee),
              );
            },
          ),
          GoRoute(
            path: '/dashboard/active-shift',
            name: 'active-shift',
            builder: (context, state) => const ActiveShiftPage(),
          ),
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
          // Rutas placeholder para la imagen
          GoRoute(
            path: '/dashboard/inventory',
            name: 'inventory',
            builder: (context, state) => const Center(child: Text('Inventario - TODO')),
          ),
          GoRoute(
            path: '/dashboard/audit',
            name: 'audit',
            builder: (context, state) => const AuditPage(),
          ),
          GoRoute(
            path: '/dashboard/reports',
            name: 'reports',
            builder: (context, state) => const Center(child: Text('Reportes - TODO')),
          ),
        ],
      ),

      /// Special routes (without Sidebar)
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
        path: '/dashboard/break',
        name: 'break',
        pageBuilder: (context, state) => const MaterialPage(
          key: ValueKey('break-page'),
          child: BreakPage(),
        ),
      ),
    ],

    /// Redirect logic
    redirect: (context, state) {
      final authState = context.read<AuthBloc>().state;
      final shiftState = context.read<ShiftBloc>().state;

      final isAuthenticated = authState is AuthAuthenticated;
      final isClockInRequired = authState is AuthClockInRequired;
      final isGoingToLogin = state.matchedLocation == '/login';
      final isGoingToLaborClockIn = state.matchedLocation == '/labor-clock-in';

      // 1. Guardia de Fichaje Obligatorio (Asistencia)
      if (isClockInRequired) {
        if (state.matchedLocation == '/error' ||
            state.matchedLocation == '/forbidden' ||
            isGoingToLaborClockIn) {
          return null;
        }
        return '/labor-clock-in';
      }

      // 2. Guardia de Autenticación General
      if (!isAuthenticated) {
        // Permitir solo Splash, Login y errores si no está autenticado
        if (state.matchedLocation == '/' ||
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/error' ||
            state.matchedLocation == '/forbidden') {
          return null;
        }
        return '/login';
      }

      // 3. Si está autenticado y está en Login o Splash o Labor Clock-In -> Al Dashboard
      if (isAuthenticated &&
          (isGoingToLogin || state.matchedLocation == '/' || isGoingToLaborClockIn)) {
        return '/dashboard';
      }

      // 3. Lógica de Negocio (Turnos)
      // Solo aplicamos estas reglas si no estamos "cargando" el turno
      if (shiftState is! ShiftInitial && shiftState is! ShiftLoading) {
        // Si no ha iniciado turno, forzar Clock-In (a menos que ya esté allí)
        if (shiftState is ShiftInactive && !state.matchedLocation.contains('/clock-in')) {
          return '/dashboard/clock-in';
        }

        // Si ya inició turno y está en Clock-In, mandarlo al menú
        if (shiftState is ShiftActive && state.matchedLocation.contains('/clock-in')) {
          return '/dashboard';
        }

        // NOTA: La navegación desde /dashboard/break a /dashboard cuando ShiftActive
        // se maneja de forma imperativa en BreakPage para evitar conflictos de GlobalKey

        // Si está en pausa, no dejarle navegar por el dashboard (solo ver pantalla de descanso)
        if (shiftState is ShiftOnBreak &&
            state.matchedLocation.startsWith('/dashboard') &&
            state.matchedLocation != '/dashboard/break') {
          return '/dashboard/break';
        }
      }

      // 4. Guardia de Roles (Admin)
      if (state.matchedLocation.contains('/employees') ||
          state.matchedLocation.contains('/settings')) {
        // isAuthenticated ya asegura que es AuthAuthenticated por el flujo previo
        if ((authState).employee.role != Role.admin) {
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
/// Supports multiple streams for complex navigation logic
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(List<Stream<dynamic>> streams) {
    notifyListeners();
    _subscriptions = streams.map((stream) {
      return stream.asBroadcastStream().listen(
            (dynamic _) => notifyListeners(),
          );
    }).toList();
  }

  late final List<StreamSubscription<dynamic>> _subscriptions;

  @override
  void dispose() {
    for (final subscription in _subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }
}
