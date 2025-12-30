import 'package:equatable/equatable.dart';
import '../../domain/entities/audit_event_entity.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';

abstract class AuditState extends Equatable {
  const AuditState();

  @override
  List<Object?> get props => [];
}

/// Estado inicial
class AuditInitial extends AuditState {
  const AuditInitial();
}

/// Estado de carga
class AuditLoading extends AuditState {
  const AuditLoading();
}

/// Estado con eventos cargados
class AuditLoaded extends AuditState {
  final List<AuditEventEntity> events;
  final AuditFilter? currentFilter;
  final AuditSort currentSort;
  final int totalCount;

  const AuditLoaded({
    required this.events,
    this.currentFilter,
    required this.currentSort,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [events, currentFilter, currentSort, totalCount];

  AuditLoaded copyWith({
    List<AuditEventEntity>? events,
    AuditFilter? currentFilter,
    AuditSort? currentSort,
    int? totalCount,
  }) {
    return AuditLoaded(
      events: events ?? this.events,
      currentFilter: currentFilter ?? this.currentFilter,
      currentSort: currentSort ?? this.currentSort,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

/// Estado de error
class AuditError extends AuditState {
  final String message;

  const AuditError(this.message);

  @override
  List<Object?> get props => [message];
}
