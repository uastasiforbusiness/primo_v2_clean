import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../features/database/data/app_database.dart';

// Auth Imports
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Shifts Imports
import '../features/shifts/data/datasources/shift_local_datasource.dart';
import '../features/shifts/data/repositories/shift_repository_impl.dart';
import '../features/shifts/domain/repositories/shift_repository.dart';
import '../features/shifts/domain/usecases/clock_in_usecase.dart';
import '../features/shifts/domain/usecases/clock_out_usecase.dart';
import '../features/shifts/domain/usecases/start_break_usecase.dart';
import '../features/shifts/domain/usecases/end_break_usecase.dart';
import '../features/shifts/presentation/bloc/shift_bloc.dart';

// Employee Imports
import '../features/employees/data/datasources/employee_local_datasource.dart';
import '../features/employees/data/datasources/employee_local_datasource_impl.dart';
import '../features/employees/data/repositories/employee_repository_impl.dart';
import '../features/employees/domain/repositories/employee_repository.dart';
import '../features/employees/domain/usecases/get_employees_usecase.dart';
import '../features/employees/domain/usecases/create_employee_usecase.dart';
import '../features/employees/domain/usecases/update_employee_usecase.dart';
import '../features/employees/domain/usecases/delete_employee_usecase.dart';
import '../features/employees/presentation/bloc/employee_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // Core
  sl.registerLazySingleton<Uuid>(() => const Uuid());
  sl.registerLazySingleton<AppDatabase>(AppDatabase.new);

  // ==================== AUTH FEATURE ====================
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(database: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));

  // Cambiado a LazySingleton para que el Router y la UI compartan la misma instancia
  sl.registerLazySingleton(() => AuthBloc(loginWithPinUseCase: sl()));

  // ==================== SHIFTS FEATURE ====================
  sl.registerLazySingleton<ShiftLocalDataSource>(
    () => ShiftLocalDataSourceImpl(database: sl(), uuid: sl()),
  );
  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));
  sl.registerLazySingleton(() => StartBreakUseCase(sl()));
  sl.registerLazySingleton(() => EndBreakUseCase(sl()));

  // Cambiado a LazySingleton para que el Router y la UI compartan la misma instancia
  sl.registerLazySingleton(
    () => ShiftBloc(
      clockInUseCase: sl(),
      clockOutUseCase: sl(),
      startBreakUseCase: sl(),
      endBreakUseCase: sl(),
      shiftRepository: sl(),
    ),
  );

  // ==================== EMPLOYEE FEATURE ====================
  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(sl(), sl()),
  );
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => CreateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeUseCase(sl()));

  sl.registerFactory(
    () => EmployeeBloc(
      getEmployeesUseCase: sl(),
      createEmployeeUseCase: sl(),
      updateEmployeeUseCase: sl(),
      deleteEmployeeUseCase: sl(),
    ),
  );
}
