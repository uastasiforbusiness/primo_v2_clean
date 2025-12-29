import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../features/database/data/app_database.dart';

// Auth Imports
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

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
import '../features/shifts/domain/usecases/start_break_usecase.dart';
import '../features/shifts/domain/usecases/end_break_usecase.dart';
import '../features/shifts/presentation/bloc/shift_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  //! Features - Auth
  // Bloc - ¡CRÍTICO! Debe ser Singleton para que el Router escuche al mismo que la UI
  sl.registerLazySingleton(() => AuthBloc(
    loginWithPinUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(database: sl()),
  );

  //! Features - Employees
  // Bloc
  sl.registerFactory(() => EmployeeBloc( // Este puede ser Factory, se usa bajo demanda
    getEmployeesUseCase: sl(),
    createEmployeeUseCase: sl(),
    updateEmployeeUseCase: sl(),
    deleteEmployeeUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => CreateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => UpdateEmployeeUseCase(sl()));
  sl.registerLazySingleton(() => DeleteEmployeeUseCase(sl()));

  // Repository
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(database: sl(), uuid: sl()),
  );

  //! Features - Shifts
  // Bloc - ¡CRÍTICO! Singleton también, el router lo necesita para saber si clock-in/out
  sl.registerLazySingleton(() => ShiftBloc(
    clockInUseCase: sl(),
    clockOutUseCase: sl(),
    startBreakUseCase: sl(),
    endBreakUseCase: sl(),
  ));

  // Use cases
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));
  sl.registerLazySingleton(() => StartBreakUseCase(sl()));
  sl.registerLazySingleton(() => EndBreakUseCase(sl()));

  // Repository
  sl.registerLazySingleton<ShiftRepository>(
    () => ShiftRepositoryImpl(localDataSource: sl()),
  );

  // Data sources
  sl.registerLazySingleton<ShiftLocalDataSource>(
    () => ShiftLocalDataSource(database: sl()),
  );

  //! External
  final database = AppDatabase();
  sl.registerLazySingleton(() => database);
  sl.registerLazySingleton(() => const Uuid());
}
