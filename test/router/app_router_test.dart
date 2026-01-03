import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/core/router/app_router.dart';
import 'package:primo_v2/core/shared_kernel/money.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_state.dart';
import 'package:primo_v2/features/shifts/domain/entities/shift_entity.dart';
import 'package:primo_v2/features/shifts/presentation/bloc/shift_state.dart';

void main() {
  group('AppRouter Configuration Tests', () {
    test('AppRouter.router is properly configured', () {
      // Verify that AppRouter.router exists and is a GoRouter
      expect(AppRouter.router, isA<GoRouter>());
    });

    test('AppRouter has initial location set to /', () {
      // Verify router is configured with initial location
      expect(AppRouter.router.routeInformationProvider.value.uri.path, '/');
    });
  });

  /*
   * NOTE: Router redirect and guard logic tests are commented out because:
   * 1. GoRouter.redirect is not a public method
   * 2. GoRouterState.blank() doesn't exist in go_router 13.x
   * 3. Redirect logic requires BuildContext which is not available in unit tests
   *
   * These tests should be rewritten as widget tests or integration tests.
   * See NAVIGATION_ARCHITECTURE.md Phase 4 for proper testing strategy.
   */

  group('Entity Creation Tests', () {
    test('Create EmployeeEntity with all required fields', () {
      final now = DateTime.now();

      final employee = EmployeeEntity(
        id: 'test-001',
        name: 'Test',
        lastName: 'User',
        emergencyPhone: '+1234567890',
        role: Role.staff,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      expect(employee.id, 'test-001');
      expect(employee.name, 'Test');
      expect(employee.lastName, 'User');
      expect(employee.role, Role.staff);
      expect(employee.isActive, true);
    });

    test('Create admin EmployeeEntity', () {
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
      expect(admin.role.canManageEmployees, true);
    });
  });

  group('ShiftEntity Creation Tests', () {
    test('Create ShiftEntity with all required fields', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'test-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      expect(shift.id, 'shift-001');
      expect(shift.employeeId, 'test-001');
      expect(shift.initialCash.amount, 100.0);
      expect(shift.isActive, true);
    });

    test('ShiftEntity isActive returns true when endedAt is null', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'test-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      expect(shift.isActive, true);
    });

    test('ShiftEntity isActive returns false when endedAt is set', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'test-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
        endedAt: DateTime.now(),
      );

      expect(shift.isActive, false);
    });
  });

  group('Auth State Tests', () {
    test('AuthUnauthenticated state', () {
      const state = AuthUnauthenticated();
      expect(state, isA<AuthUnauthenticated>());
    });

    test('AuthAuthenticated state contains employee', () {
      final now = DateTime.now();
      final employee = EmployeeEntity(
        id: 'test-001',
        name: 'Test',
        lastName: 'User',
        emergencyPhone: '+1234567890',
        role: Role.staff,
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final state = AuthAuthenticated(employee: employee);

      expect(state, isA<AuthAuthenticated>());
      expect(state.employee.id, 'test-001');
      expect(state.employee.role, Role.staff);
    });
  });

  group('Shift State Tests', () {
    test('ShiftInactive state', () {
      final state = ShiftInactive();
      expect(state, isA<ShiftInactive>());
    });

    test('ShiftActive state contains shift', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'test-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      final state = ShiftActive(shift);

      expect(state, isA<ShiftActive>());
      expect(state.shift.id, 'shift-001');
      expect(state.shift.isActive, true);
    });

    test('ShiftOnBreak state contains shift', () {
      final shift = ShiftEntity(
        id: 'shift-001',
        employeeId: 'test-001',
        cashRegisterId: 'register-001',
        initialCash: Money.fromDouble(100.0),
        startedAt: DateTime.now(),
      );

      final state = ShiftOnBreak(shift);

      expect(state, isA<ShiftOnBreak>());
      expect(state.shift.id, 'shift-001');
    });
  });

  group('Role Permissions Tests', () {
    test('Admin role has all permissions', () {
      expect(Role.admin.canManageEmployees, true);
      expect(Role.admin.canAccessReports, true);
      expect(Role.admin.canOperatePOS, true);
      expect(Role.admin.canAccessKitchen, true);
    });

    test('Staff role has limited permissions', () {
      expect(Role.staff.canManageEmployees, false);
      expect(Role.staff.canAccessReports, false);
      expect(Role.staff.canOperatePOS, true);
      expect(Role.staff.canAccessKitchen, false);
    });

    test('Supervisor role has management permissions', () {
      expect(Role.supervisor.canManageEmployees, true);
      expect(Role.supervisor.canAccessReports, true);
      expect(Role.supervisor.canOperatePOS, false);
      expect(Role.supervisor.canAccessKitchen, false);
    });

    test('Kitchen role has kitchen access only', () {
      expect(Role.kitchen.canManageEmployees, false);
      expect(Role.kitchen.canAccessReports, false);
      expect(Role.kitchen.canOperatePOS, false);
      expect(Role.kitchen.canAccessKitchen, true);
    });
  });

  group('Money Value Object Tests', () {
    test('Money.fromDouble creates valid money', () {
      final money = Money.fromDouble(100.50);
      expect(money.amount, 100.50);
    });

    test('Money.zero creates zero money', () {
      final money = Money.zero();
      expect(money.amount, 0.0);
      expect(money.isZero, true);
    });

    test('Money addition works correctly', () {
      final money1 = Money.fromDouble(100.0);
      final money2 = Money.fromDouble(50.0);
      final result = money1 + money2;

      expect(result.amount, 150.0);
    });

    test('Money subtraction works correctly', () {
      final money1 = Money.fromDouble(100.0);
      final money2 = Money.fromDouble(50.0);
      final result = money1 - money2;

      expect(result.amount, 50.0);
    });

    test('Money multiplication works correctly', () {
      final money = Money.fromDouble(100.0);
      final result = money * 2;

      expect(result.amount, 200.0);
    });

    test('Money comparison operators work correctly', () {
      final money1 = Money.fromDouble(100.0);
      final money2 = Money.fromDouble(50.0);

      expect(money1 > money2, true);
      expect(money2 < money1, true);
      expect(money1 >= money2, true);
      expect(money2 <= money1, true);
    });

    test('Money cannot be negative on creation', () {
      expect(() => Money.fromDouble(-10.0), throwsArgumentError);
    });

    test('Money subtraction cannot result in negative', () {
      final money1 = Money.fromDouble(50.0);
      final money2 = Money.fromDouble(100.0);

      expect(() => money1 - money2, throwsArgumentError);
    });

    test('Money formatting works correctly', () {
      final money = Money.fromDouble(100.50);
      expect(money.toFormattedString(), '\$100.50');
    });
  });
}
