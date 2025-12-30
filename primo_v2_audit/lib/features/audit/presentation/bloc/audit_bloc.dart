import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_audit_events_usecase.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';
import 'audit_event.dart';
import 'audit_state.dart';

class AuditBloc extends Bloc<AuditEvent, AuditState> {
  final GetAuditEventsUseCase getAuditEventsUseCase;

  // Estado interno para mantener filtros y ordenamiento actuales
  AuditFilter? _currentFilter;
  AuditSort _currentSort = AuditSort.defaultSort;

  AuditBloc({
    required this.getAuditEventsUseCase,
  }) : super(const AuditInitial()) {
    on<LoadAuditEvents>(_onLoadAuditEvents);
    on<ApplyAuditFilter>(_onApplyAuditFilter);
    on<ChangeAuditSort>(_onChangeAuditSort);
    on<ClearAuditFilters>(_onClearAuditFilters);
    on<RefreshAuditEvents>(_onRefreshAuditEvents);
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

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(AuditLoaded(
        events: events,
        currentFilter: _currentFilter,
        currentSort: _currentSort,
        totalCount: events.length,
      )),
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

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(AuditLoaded(
        events: events,
        currentFilter: _currentFilter,
        currentSort: _currentSort,
        totalCount: events.length,
      )),
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

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(AuditLoaded(
        events: events,
        currentFilter: _currentFilter,
        currentSort: _currentSort,
        totalCount: events.length,
      )),
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

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(AuditLoaded(
        events: events,
        currentFilter: null,
        currentSort: _currentSort,
        totalCount: events.length,
      )),
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

    result.fold(
      (failure) => emit(AuditError(failure.message)),
      (events) => emit(AuditLoaded(
        events: events,
        currentFilter: _currentFilter,
        currentSort: _currentSort,
        totalCount: events.length,
      )),
    );
  }
}
