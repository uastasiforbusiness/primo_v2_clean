import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../features/database/data/app_database.dart';

// Auth Imports
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/domain/usecases/clock_in_usecase.dart';
import '../features/auth/domain/usecases/clock_out_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/shift/shift_bloc.dart';

// Employee Imports
import '../features/employees/data/datasources/employee_local_datasource.dart';
import '../features/employees/data/datasources/employee_local_datasource_impl.dart';
import '../features/employees/data/repositories/employee_repository_impl.dart';
import '../features/employees/domain/repositories/employee_repository.dart';
import '../features/employees/domain/usecases/get_employees_usecase.dart';
import '../features/employees/domain/usecases/create_employee_usecase.dart';
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
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));

  sl.registerFactory(() => AuthBloc(loginWithPinUseCase: sl()));
  sl.registerFactory(() => ShiftBloc(
    clockInUseCase: sl(),
    clockOutUseCase: sl(),
    authRepository: sl(),
  ));

  // ==================== EMPLOYEE FEATURE ====================
  sl.registerLazySingleton<EmployeeLocalDataSource>(
    () => EmployeeLocalDataSourceImpl(sl()),
  );
  sl.registerLazySingleton<EmployeeRepository>(
    () => EmployeeRepositoryImpl(localDataSource: sl()),
  );
  sl.registerLazySingleton(() => GetEmployeesUseCase(sl()));
  sl.registerLazySingleton(() => CreateEmployeeUseCase(sl()));

  sl.registerFactory(() => EmployeeBloc(
    getEmployeesUseCase: sl(),
    createEmployeeUseCase: sl(),
  ));
}
