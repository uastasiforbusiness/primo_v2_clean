import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/core/router/app_router.dart';
import 'package:primo_v2/core/shared_kernel/money.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/shifts/domain/entities/shift_entity.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';

void main() {
  group('Router Configuration Tests', () {
    test('AppRouter is properly configured', () {
      // Verify that AppRouter.router exists and is a GoRouter
      expect(AppRouter.router, isA<GoRouter>());
    });

    /*
     * NOTE: Router configuration tests that access currentConfiguration
     * require a full widget testing context with MaterialApp.router.
     * These should be moved to widget tests.
     */

    // test('Router has correct initial configuration', () {
    //   final router = AppRouter.router;
    //   // Requires widget test context
    //   expect(router.routerDelegate.currentConfiguration.uri.path, isNotEmpty);
    // });
  });

  group('Employee Entity Creation Tests', () {
    test('Create employee entity with all required fields', () {
      final now = DateTime.now();

      final employee = EmployeeEntity(
        id: 'emp-001',
        name: 'John',
        lastName: 'Doe',
        emergencyPhone: '+1234567890',
        role: Role.staff,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(employee.id, 'emp-001');
      expect(employee.name, 'John');
      expect(employee.lastName, 'Doe');
      expect(employee.role, Role.staff);
      expect(employee.isActive, true);
    });

    test('Create admin employee entity', () {
      final now = DateTime.now();

      final admin = EmployeeEntity(
        id: 'admin-001',
        name: 'Admin',
        lastName: 'User',
        emergencyPhone: '+1234567890',
        role: Role.admin,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(admin.role, Role.admin);
    });
  });

  group('Shift Entity Creation Tests', () {
    test('Create shift entity with all required fields', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'emp-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      expect(shift.id, 'shift-001');
      expect(shift.employeeId, 'emp-001');
      expect(shift.initialCash.amount, 100.0);
      expect(shift.isActive, true);
    });
  });

  group('Auth State Tests', () {
    test('AuthUnauthenticated state', () {
      const state = AuthUnauthenticated();
      expect(state, isA<AuthUnauthenticated>());
    });

    test('AuthAuthenticated state with employee', () {
      final now = DateTime.now();
      final employee = EmployeeEntity(
        id: 'emp-001',
        name: 'John',
        lastName: 'Doe',
        emergencyPhone: '+1234567890',
        role: Role.staff,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final state = AuthAuthenticated(employee: employee);

      expect(state, isA<AuthAuthenticated>());
      expect(state.employee.id, 'emp-001');
    });
  });

  group('Shift State Tests', () {
    test('ShiftInactive state', () {
      final state = ShiftInactive();
      expect(state, isA<ShiftInactive>());
    });

    test('ShiftActive state with shift', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'emp-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      final state = ShiftActive(shift);

      expect(state, isA<ShiftActive>());
      expect(state.shift.id, 'shift-001');
    });

    test('ShiftOnBreak state with shift', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'emp-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      final state = ShiftOnBreak(shift);

      expect(state, isA<ShiftOnBreak>());
      expect(state.shift.id, 'shift-001');
    });
  });

  group('Money Value Object Tests', () {
    test('Create money from double', () {
      final money = Money.fromDouble(100.50);
      expect(money.amount, 100.50);
    });

    test('Create zero money', () {
      final money = Money.zero();
      expect(money.amount, 0.0);
      expect(money.isZero, true);
    });

    test('Money addition', () {
      final money1 = Money.fromDouble(100.0);
      final money2 = Money.fromDouble(50.0);
      final result = money1 + money2;

      expect(result.amount, 150.0);
    });

    test('Money subtraction', () {
      final money1 = Money.fromDouble(100.0);
      final money2 = Money.fromDouble(50.0);
      final result = money1 - money2;

      expect(result.amount, 50.0);
    });

    test('Money cannot be negative', () {
      expect(() => Money.fromDouble(-10.0), throwsArgumentError);
    });

    test('Money subtraction cannot result in negative', () {
      final money1 = Money.fromDouble(50.0);
      final money2 = Money.fromDouble(100.0);

      expect(() => money1 - money2, throwsArgumentError);
    });
  });

  group('Role Value Object Tests', () {
    test('Role has correct values', () {
      expect(Role.admin, isA<Role>());
      expect(Role.staff, isA<Role>());
      expect(Role.supervisor, isA<Role>());
      expect(Role.kitchen, isA<Role>());
    });

    test('Role permissions - admin can manage employees', () {
      expect(Role.admin.canManageEmployees, true);
      expect(Role.staff.canManageEmployees, false);
    });

    test('Role permissions - staff can operate POS', () {
      expect(Role.staff.canOperatePOS, true);
      expect(Role.kitchen.canOperatePOS, false);
    });

    test('Role from string conversion', () {
      final role = Role.fromString('ADMIN');
      expect(role, Role.admin);
    });

    test('Role to value conversion', () {
      expect(Role.admin.toValue(), 'ADMIN');
      expect(Role.staff.toValue(), 'STAFF');
    });
  });

  /*
   * NOTE: The following tests are commented out because they require
   * widget testing or integration testing with a real router context.
   *
   * GoRouter's redirect logic is not directly testable through unit tests
   * because:
   * 1. GoRouter.redirect is not a public method
   * 2. GoRouterState cannot be easily mocked
   * 3. The redirect function requires a BuildContext
   *
   * These tests should be rewritten as:
   * - Widget tests using flutter_test and testWidgets
   * - Integration tests with a real MaterialApp.router
   *
   * See NAVIGATION_ARCHITECTURE.md Phase 4 for proper testing strategy.
   */

  /*
  group('Integration Tests - Complete Navigation Flows [REQUIRES WIDGET TESTS]', () {
    test('Full employee flow: login → clock-in → active-shift', () {
      // This test requires widget testing framework
      // See: https://docs.flutter.dev/cookbook/testing/widget/introduction
    });

    test('Admin flow: login → dashboard → employees', () {
      // This test requires widget testing framework
    });

    test('Employee restricted access to admin routes', () {
      // This test requires widget testing framework
    });

    test('Error handling and edge cases', () {
      // This test requires widget testing framework
    });

    test('State transitions maintain consistency', () {
      // This test requires widget testing framework
    });
  });
  */
}
