import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import '../features/database/data/app_database.dart';
import '../features/auth/data/datasources/auth_local_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_with_pin_usecase.dart';
import '../features/auth/domain/usecases/clock_in_usecase.dart';
import '../features/auth/domain/usecases/clock_out_usecase.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ==================== Core ====================
  sl.registerLazySingleton<Uuid>(() => const Uuid());

  // ==================== Database ====================
  sl.registerLazySingleton<AppDatabase>(() => AppDatabase());

  // ==================== Auth Feature ====================
  
  // Data sources
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(
      database: sl(),
      uuid: sl(),
    ),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      localDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => LoginWithPinUseCase(sl()));
  sl.registerLazySingleton(() => ClockInUseCase(sl()));
  sl.registerLazySingleton(() => ClockOutUseCase(sl()));

  // BLoC
  sl.registerFactory(
    () => AuthBloc(
      loginWithPinUseCase: sl(),
      clockInUseCase: sl(),
      clockOutUseCase: sl(),
      authRepository: sl(),
    ),
  );
}
