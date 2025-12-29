// Basic app initialization test for PRIMO V2 POS system

import 'package:flutter_test/flutter_test.dart';
import 'package:primo_v2/di/injection_container.dart';
import 'package:primo_v2/features/auth/domain/repositories/auth_repository.dart';
import 'package:primo_v2/features/database/data/app_database.dart';
import 'package:primo_v2/features/employees/domain/repositories/employee_repository.dart';
import 'package:primo_v2/features/shifts/domain/repositories/shift_repository.dart';

void main() {
  test('Dependency injection initializes without errors', () async {
    // Test that all dependencies can be registered
    await initDependencies();

    // Verify that critical dependencies are registered
    expect(sl.isRegistered<AppDatabase>(), true);
    expect(sl.isRegistered<AuthRepository>(), true);
    expect(sl.isRegistered<ShiftRepository>(), true);
    expect(sl.isRegistered<EmployeeRepository>(), true);
  });
}
