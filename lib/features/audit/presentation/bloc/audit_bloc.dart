import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/audit_repository.dart';
import '../../domain/usecases/get_audit_events_usecase.dart';
import '../../domain/usecases/log_audit_event_usecase.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';
import 'audit_event.dart';
import 'audit_state.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final GetAuditEventsUseCase getAuditEventsUseCase;
  final LogAuditEventUseCase logAuditEventUseCase;
  final AuditRepository repository;

  // Estado interno para mantener filtros y ordenamiento actuales
  AuditFilter? _currentFilter;
  AuditSort _currentSort = AuditSort.defaultSort;

  AuditBloc({
    required this.getAuditEventsUseCase,
    required this.logAuditEventUseCase,
    required this.repository,
  }) : super(const AuditInitial()) {
    on<LoadAuditEvents>(_onLoadAuditEvents);
    on<ApplyAuditFilter>(_onApplyAuditFilter);
    on<ChangeAuditSort>(_onChangeAuditSort);
    on<ClearAuditFilters>(_onClearAuditFilters);
    on<RefreshAuditEvents>(_onRefreshAuditEvents);
    on<LogAuditEventRequested>(_onLogAuditEvent);
  }

  Future<void> _onLoadAuditEvents(
    LoadAuditEvents event,
    Emitter<AuditState> emit,
  ) async {
    emit(const AuditLoading());

    // Actualizar estado interno
    _currentFilter = event.filter;
    if (event.sort != null) {
      _currentSort = event.sort!;
    }

    final result = await getAuditEventsUseCase(
      filter: _currentFilter,
      sort: _currentSort,
      limit: event.limit,
    );

    // Obtener el total de eventos
    final countResult = await repository.getEventCount(filter: _currentFilter);
    final totalCount = countResult.getOrElse(() => 0);

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(
        AuditLoaded(
          events: events,
          currentFilter: _currentFilter,
          currentSort: _currentSort,
          totalCount: totalCount,
        ),
      ),
    );
  }

  Future<void> _onApplyAuditFilter(
    ApplyAuditFilter event,
    Emitter<AuditState> emit,
  ) async {
    emit(const AuditLoading());

    _currentFilter = event.filter;

    final result = await getAuditEventsUseCase(
      filter: _currentFilter,
      sort: _currentSort,
    );

    // Obtener el total de eventos
    final countResult = await repository.getEventCount(filter: _currentFilter);
    final totalCount = countResult.getOrElse(() => 0);

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(
        AuditLoaded(
          events: events,
          currentFilter: _currentFilter,
          currentSort: _currentSort,
          totalCount: totalCount,
        ),
      ),
    );
  }

  Future<void> _onChangeAuditSort(
    ChangeAuditSort event,
    Emitter<AuditState> emit,
  ) async {
    emit(const AuditLoading());

    _currentSort = event.sort;

    final result = await getAuditEventsUseCase(
      filter: _currentFilter,
      sort: _currentSort,
    );

    // Obtener el total de eventos
    final countResult = await repository.getEventCount(filter: _currentFilter);
    final totalCount = countResult.getOrElse(() => 0);

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(
        AuditLoaded(
          events: events,
          currentFilter: _currentFilter,
          currentSort: _currentSort,
          totalCount: totalCount,
        ),
      ),
    );
  }

  Future<void> _onClearAuditFilters(
    ClearAuditFilters event,
    Emitter<AuditState> emit,
  ) async {
    emit(const AuditLoading());

    _currentFilter = null;

    final result = await getAuditEventsUseCase(
      filter: null,
      sort: _currentSort,
    );

    // Obtener el total de eventos
    final countResult = await repository.getEventCount(filter: null);
    final totalCount = countResult.getOrElse(() => 0);

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(
        AuditLoaded(
          events: events,
          currentFilter: null,
          currentSort: _currentSort,
          totalCount: totalCount,
        ),
      ),
    );
  }

  Future<void> _onRefreshAuditEvents(
    RefreshAuditEvents event,
    Emitter<AuditState> emit,
  ) async {
    // Recargar con los filtros y ordenamiento actuales
    final result = await getAuditEventsUseCase(
      filter: _currentFilter,
      sort: _currentSort,
    );

    // Obtener el total de eventos
    final countResult = await repository.getEventCount(filter: _currentFilter);
    final totalCount = countResult.getOrElse(() => 0);

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(
        AuditLoaded(
          events: events,
          currentFilter: _currentFilter,
          currentSort: _currentSort,
          totalCount: totalCount,
        ),
      ),
    );
  }

  Future<void> _onLogAuditEvent(
    LogAuditEventRequested event,
    Emitter<AuditState> emit,
  ) async {
    final result = await logAuditEventUseCase(
      eventType: event.eventType,
      employeeId: event.employeeId,
      metadata: event.metadata,
    );

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (_) => null,
    );
  }
}
