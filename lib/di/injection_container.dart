import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

// Audit Imports
import '../features/audit/data/datasources/audit_local_datasource.dart';
import '../features/audit/data/repositories/audit_repository_impl.dart';
import '../features/audit/domain/repositories/audit_repository.dart';
import '../features/audit/domain/usecases/get_audit_events_usecase.dart';
import '../features/audit/domain/usecases/log_audit_event_usecase.dart';
import '../features/audit/presentation/bloc/audit_bloc.dart';
// Auth Imports
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../infrastructure/database/app_database.dart';
// Employee Imports
import '../features/employees/data/datasources/employee_local_datasource.dart';
import '../features/employees/data/datasources/employee_local_datasource_impl.dart';
import '../features/employees/data/repositories/employee_repository_impl.dart';
import '../features/employees/domain/repositories/employee_repository.dart';
import '../features/employees/domain/usecases/create_employee_usecase.dart';
import '../features/employees/domain/usecases/delete_employee_usecase.dart';
import '../features/employees/domain/usecases/get_employees_usecase.dart';
import '../features/employees/domain/usecases/update_employee_usecase.dart';
import '../features/employees/presentation/bloc/employee_bloc.dart';
// Shift Imports
import '../features/shifts/data/datasources/shift_local_datasource.dart';
import '../features/shifts/data/repositories/shift_repository_impl.dart';
import '../features/shifts/domain/repositories/shift_repository.dart';
import '../features/shifts/domain/usecases/clock_in_usecase.dart';
import '../features/shifts/domain/usecases/clock_out_usecase.dart';
import '../features/shifts/domain/usecases/end_break_usecase.dart';
import '../features/shifts/domain/usecases/start_break_usecase.dart';
import '../features/shifts/presentation/bloc/shift_bloc.dart';

final sl = GetIt.instance;

// CORRECCIÓN 1: Renombrado de init a initDependencies para coincidir con main.dart
Future<void> initDependencies() async {
  //! External
  sl.registerLazySingleton(AppDatabase.new);
  sl.registerLazySingleton(() => const Uuid());

  //! Features - Auth
  // Cambiado a registerLazySingleton para que el router y la UI compartan la misma instancia
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginWithPinUseCase: sl(),
    ),
  );
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(database: sl(), uuid: sl()),
  );

  //! Features - Employees
  sl.registerFactory(
    () => EmployeeBloc(
      getEmployeesUseCase: sl(),
      createEmployeeUseCase: sl(),
      updateEmployeeUseCase: sl(),
      deleteEmployeeUseCase: sl(),
    ),
  );

  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => CreateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeUseCase(sl()));

  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(localDataSource: sl()),
  );

  // CORRECCIÓN 4: Agregado el parámetro uuid faltante (usando parámetros posicionales)
  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(sl(), sl()),
  );

  //! Features - Shifts
  // Cambiado a registerLazySingleton para que el router y la UI compartan la misma instancia
  sl.registerLazySingleton<ShiftBloc>(
    () => ShiftBloc(
      clockInUseCase: sl(),
      clockOutUseCase: sl(),
      startBreakUseCase: sl(),
      endBreakUseCase: sl(),
      shiftRepository: sl(),
    ),
  );

  // CORRECCIÓN 3: Usar argumentos posicionales para los UseCases
  // Los constructores usan parámetros posicionales (this.repository)
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));
  sl.registerLazySingleton(() => StartBreakUseCase(sl()));
  sl.registerLazySingleton(() => EndBreakUseCase(sl()));

  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(localDataSource: sl()),
  );

  // CORRECCIÓN 2: Instanciar la implementación (Impl) con uuid, no la clase abstracta
  sl.registerLazySingleton<ShiftLocalDataSource>(
    () => ShiftLocalDataSourceImpl(database: sl(), uuid: sl()),
  );

  // Asegurar integridad de datos iniciales (Admin user)
  await sl<AppDatabase>().ensureAdminUser();

  //! Features - Audit
  sl.registerLazySingleton<AuditLocalDataSource>(
    () => AuditLocalDataSourceImpl(database: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<AuditRepository>(
    () => AuditRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LogAuditEventUseCase(sl()));
  sl.registerLazySingleton(() => GetAuditEventsUseCase(sl()));

  sl.registerFactory(
    () => AuditBloc(
      getAuditEventsUseCase: sl(),
    ),
  );
}
