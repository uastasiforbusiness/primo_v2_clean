// ==================== AGREGAR ESTOS IMPORTS AL ARCHIVO lib/di/injection_container.dart ====================

// Audit Imports
import '../features/audit/data/datasources/audit_local_datasource.dart';
import '../features/audit/data/repositories/audit_repository_impl.dart';
import '../features/audit/domain/repositories/audit_repository.dart';
import '../features/audit/domain/usecases/log_audit_event_usecase.dart';
import '../features/audit/domain/usecases/get_audit_events_usecase.dart';
import '../features/audit/presentation/bloc/audit_bloc.dart';

// ==================== AGREGAR ESTA SECCIÓN DENTRO DE initDependencies() ====================

  // ==================== AUDIT FEATURE ====================
  void sl.registerLazySingleton<AuditLocalDataSource>(
    (), => ,AuditLocalDataSourceImpl(database = sl(), uuid = sl()),
  );
  void sl.registerLazySingleton<AuditRepository>(
    (), => ,AuditRepositoryImpl(localDataSource = sl()),
  );
  void sl.registerLazySingleton(() => LogAuditEventUseCase(sl()));
  void sl.registerLazySingleton(() => GetAuditEventsUseCase(sl()));

  void sl.registerFactory((), => ,AuditBloc(
    getAuditEventsUseCase = sl(),
  ),);
