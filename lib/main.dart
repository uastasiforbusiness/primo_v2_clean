import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

import 'core/router/app_router.dart';
import 'di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/database/data/app_database.dart';
import 'features/shifts/presentation/bloc/shift_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  // Validate database integrity (read-only check)
  await _validateDatabaseIntegrity();

  runApp(const PrimoApp());
}

/// Bootstrap validation - READ ONLY
/// Validates database integrity without mutations.
/// If admin user is corrupted, delete the database file and restart.
Future<void> _validateDatabaseIntegrity() async {
  final logger = Logger();
  final db = sl<AppDatabase>();

  // Expected admin PIN hash (SHA-256 of "1234")
  const expectedPinHash =
      '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4';

  final existingAdmin = await db.getEmployeeById('admin-001');

  if (existingAdmin == null) {
    logger.e('❌ CRITICAL: Admin user not found in database');
    logger.e('   This should only happen on first run');
    logger.e('   If this persists, delete the database file and restart');
    throw StateError('Admin user not found - database integrity compromised');
  }

  if (existingAdmin.pinHash != expectedPinHash) {
    logger.e('❌ CRITICAL: Admin user has corrupted PIN hash');
    logger.e('   Expected: $expectedPinHash');
    logger.e('   Found:    ${existingAdmin.pinHash}');
    logger.e('   → Delete database file and restart application');
    throw StateError(
        'Admin PIN hash corrupted - database integrity compromised');
  }

  logger.i('✅ Database integrity validated - Admin user OK');
}

class PrimoApp extends StatelessWidget {
  const PrimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<ShiftBloc>(create: (_) => sl<ShiftBloc>()),
      ],
      child: MaterialApp.router(
        title: 'PRIMO V2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
          cardTheme: const CardThemeData(
            elevation: 2,
            color: Colors.white,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              elevation: 2,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
