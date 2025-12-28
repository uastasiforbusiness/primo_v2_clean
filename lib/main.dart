import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/database/data/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependencies
  await initDependencies();

  // Ensure admin user exists
  await _ensureAdminUserExists();

  runApp(const PrimoApp());
}

Future<void> _ensureAdminUserExists() async {
  final logger = Logger();
  final db = sl<AppDatabase>();
  final existingAdmin = await db.getEmployeeById('admin-001');

  const correctPinHash =
      '03ac674216f3e15c761ee1a5e255f067953623c8b388b4459e13f978d7c846f4';

  if (existingAdmin == null) {
    logger.i('⚠️ Admin user not found, creating...');
    await db.insertEmployee(
      EmployeesCompanion.insert(
        id: 'admin-001',
        name: 'Administrador',
        lastName: 'Sistema',
        emergencyPhone: '000000000',
        role: 'ADMIN',
        pinHash: correctPinHash,
        email: const Value('admin@primo.com'),
      ),
    );
    logger.i('✅ Admin user created with PIN: 1234');
  } else if (existingAdmin.pinHash != correctPinHash) {
    logger.i('⚠️ Admin user has incorrect PIN hash, fixing...');
    logger.i('   Old hash: ${existingAdmin.pinHash}');
    logger.i('   New hash: $correctPinHash');

    await db.updateEmployee(
      const EmployeesCompanion(
        id: Value('admin-001'),
        pinHash: Value(correctPinHash),
      ),
    );
    logger.i('✅ Admin PIN updated to: 1234');
  } else {
    logger.i('✅ Admin user exists with correct PIN hash');
  }
}

class PrimoApp extends StatelessWidget {
  const PrimoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthBloc>(),
      child: MaterialApp(
        title: 'PRIMO V2',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
          ),
          useMaterial3: true,
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
        home: const LoginPage(),
      ),
    );
  }
}
