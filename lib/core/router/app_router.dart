import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_bloc.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/features/auth/presentation/pages/login_page.dart';
import 'package:primo_v2/features/splash/presentation/pages/splash_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/dashboard_page.dart';
import 'package:primo_v2/features/employees/presentation/pages/employees_page.dart';
// import 'package:primo_v2/features/employees/presentation/pages/employee_detail_page.dart';
import 'package:primo_v2/features/auth/presentation/pages/clock_in_page.dart';
import 'package:primo_v2/features/shifts/presentation/pages/active_shift_page.dart';
import 'package:primo_v2/features/shifts/presentation/pages/break_page.dart';
// import 'package:primo_v2/features/settings/presentation/pages/settings_page.dart';
// import 'package:primo_v2/features/error/presentation/pages/error_page.dart';
// import 'package:primo_v2/features/error/presentation/pages/forbidden_page.dart';

/// AppRouter - Centralized navigation for PRIMO V2
/// Follows Clean Architecture and Hexagonal principles
class AppRouter {
  /// Private constructor to prevent instantiation
  AppRouter._();

  /// Singleton instance of the router
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      /// Public routes - No authentication required
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
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Error Page - TODO')),
        ),
      ),

      GoRoute(
        path: '/forbidden',
        name: 'forbidden',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Acceso Denegado')),
        ),
      ),

      /// Protected routes - Requires authentication
      /// Dashboard - Main page after login
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return const LoginPage(); // Fallback
          }
          return DashboardPage(employee: authState.employee);
        },
      ),

      /// Clock-in - Start shift (redirect handled by redirect logic)
      GoRoute(
        path: '/dashboard/clock-in',
        name: 'clock-in',
        builder: (context, state) {
          final authState = context.read<AuthBloc>().state;
          if (authState is! AuthAuthenticated) {
            return const LoginPage();
          }
          return ClockInPage(employee: authState.employee);
        },
      ),

      /// Active shift
      GoRoute(
        path: '/dashboard/active-shift',
        name: 'active-shift',
        builder: (context, state) => const ActiveShiftPage(),
      ),

      /// Break
      GoRoute(
        path: '/dashboard/break',
        name: 'break',
        builder: (context, state) => const BreakPage(),
      ),

      /// Admin routes - Requires ADMIN role
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

      /// Future routes - Prepared for expansion
      GoRoute(
        path: '/dashboard/audit',
        name: 'audit',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Audit Page - TODO')),
        ),
      ),

      GoRoute(
        path: '/dashboard/sales',
        name: 'sales',
        builder: (context, state) => const Scaffold(
          body: Center(child: Text('Sales Page - TODO')),
        ),
      ),
    ],

    /// Redirect logic - State-based navigation
    redirect: (context, state) {
      final authBloc = context.read<AuthBloc>();
      final shiftBloc = context.read<ShiftBloc>();
      
      final authState = authBloc.state;
      final shiftState = shiftBloc.state;

      /// Guard 1: Authentication required
      if (authState is! AuthAuthenticated) {
        // Allow public routes
        if (state.uri.path == '/' ||
            state.uri.path == '/login' ||
            state.uri.path == '/error' ||
            state.uri.path == '/forbidden') {
          return null;
        }
        // Redirect to login for protected routes
        return '/login';
      }

      /// Guard 2: Authenticated user should not see login
      if (state.uri.path == '/login') {
        return '/dashboard';
      }

      /// Guard 3: Shift required for operations
      // No active shift - must clock in
      if (shiftState is ShiftInactive &&
          !state.uri.path.startsWith('/dashboard/clock-in')) {
        return '/dashboard/clock-in';
      }

      // Active shift - should not see clock-in
      if (shiftState is ShiftActive &&
          state.uri.path == '/dashboard/clock-in') {
        return '/dashboard/active-shift';
      }

      // On break - should see break page
      if (shiftState is ShiftOnBreak &&
          state.uri.path != '/dashboard/break') {
        return '/dashboard/break';
      }

      /// Guard 4: Role-based access control
      if (state.uri.path.startsWith('/dashboard/employees') ||
          state.uri.path.startsWith('/dashboard/settings')) {
        // At this point, authState is guaranteed to be AuthAuthenticated (Guard 1)
        final employee = authState.employee;
        if (employee.role != Role.admin) {
          return '/forbidden';
        }
      }

      /// No redirect needed
      return null;
    },

    /// Error handling
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Error: ${state.error?.toString() ?? 'Error de navegación'}'),
      ),
    ),
  );
}