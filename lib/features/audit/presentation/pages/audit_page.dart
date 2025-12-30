import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../../di/injection_container.dart';
import '../../domain/entities/audit_event_entity.dart';
import '../../domain/value_objects/audit_filter.dart';
import '../../domain/value_objects/audit_sort.dart';
import '../bloc/audit_bloc.dart';
import '../bloc/audit_event.dart';
import '../bloc/audit_state.dart';
import '../widgets/audit_filter_dialog.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuditBloc>()..add(const LoadAuditEvents()),
      child: const _AuditPageContent(),
    );
  }
}

class _AuditPageContent extends StatelessWidget {
  const _AuditPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auditoría de Eventos'),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterDialog(context),
            tooltip: 'Filtrar',
          ),
          PopupMenuButton<AuditSortField>(
            icon: const Icon(Icons.sort),
            tooltip: 'Ordenar',
            onSelected: (field) => _changeSort(context, field),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: AuditSortField.createdAt,
                child: Text('Por Fecha'),
              ),
              const PopupMenuItem(
                value: AuditSortField.eventType,
                child: Text('Por Tipo'),
              ),
              const PopupMenuItem(
                value: AuditSortField.employeeId,
                child: Text('Por Empleado'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<AuditBloc>().add(const RefreshAuditEvents());
            },
            tooltip: 'Refrescar',
          ),
        ],
      ),
      body: BlocBuilder<AuditBloc, AuditState>(
        builder: (context, state) {
          if (state is AuditInitial || state is AuditLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuditError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${state.message}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<AuditBloc>().add(const LoadAuditEvents());
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          if (state is AuditLoaded) {
            if (state.events.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.inbox, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      state.currentFilter?.hasFilters == true
                          ? 'No se encontraron eventos con los filtros aplicados'
                          : 'No hay eventos de auditoría registrados',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    if (state.currentFilter?.hasFilters == true) ...[
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          context.read<AuditBloc>().add(const ClearAuditFilters());
                        },
                        child: const Text('Limpiar Filtros'),
                      ),
                    ],
                  ],
                ),
              );
            }

            return Column(
              children: [
                // Indicador de filtros activos
                if (state.currentFilter?.hasFilters == true)
                  Container(
                    padding: const EdgeInsets.all(12),
                    color: Colors.blue.shade50,
                    child: Row(
                      children: [
                        const Icon(Icons.filter_list, size: 20, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _buildFilterDescription(state.currentFilter!),
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.read<AuditBloc>().add(const ClearAuditFilters());
                          },
                          child: const Text('Limpiar'),
                        ),
                      ],
                    ),
                  ),

                // Lista de eventos
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.events.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final event = state.events[index];
                      return _AuditEventTile(event: event);
                    },
                  ),
                ),

                // Footer con contador
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    border: Border(top: BorderSide(color: Colors.grey.shade300)),
                  ),
                  child: Text(
                    'Total: ${state.totalCount} evento(s)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    final currentState = context.read<AuditBloc>().state;
    final currentFilter = currentState is AuditLoaded ? currentState.currentFilter : null;

    showDialog(
      context: context,
      builder: (_) => AuditFilterDialog(
        initialFilter: currentFilter,
        onApply: (filter) {
          context.read<AuditBloc>().add(ApplyAuditFilter(filter));
        },
      ),
    );
  }

  void _changeSort(BuildContext context, AuditSortField field) {
    final currentState = context.read<AuditBloc>().state;
    final currentSort =
        currentState is AuditLoaded ? currentState.currentSort : AuditSort.defaultSort;

    // Toggle order if same field
    final newOrder = currentSort.field == field && currentSort.order == AuditSortOrder.descending
        ? AuditSortOrder.ascending
        : AuditSortOrder.descending;

    context.read<AuditBloc>().add(
          ChangeAuditSort(AuditSort(field: field, order: newOrder)),
        );
  }

  String _buildFilterDescription(AuditFilter filter) {
    final parts = <String>[];

    if (filter.eventType != null) {
      parts.add('Tipo: ${filter.eventType}');
    }
    if (filter.employeeId != null) {
      parts.add('Empleado: ${filter.employeeId}');
    }
    if (filter.startDate != null) {
      parts.add('Desde: ${DateFormat('dd/MM/yyyy').format(filter.startDate!)}');
    }
    if (filter.endDate != null) {
      parts.add('Hasta: ${DateFormat('dd/MM/yyyy').format(filter.endDate!)}');
    }

    return 'Filtros activos: ${parts.join(', ')}';
  }
}

class _AuditEventTile extends StatelessWidget {
  final AuditEventEntity event;

  const _AuditEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _getEventColor(event.eventType),
          child: Icon(_getEventIcon(event.eventType), color: Colors.white),
        ),
        title: Text(
          _formatEventType(event.eventType),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (event.employeeId != null) Text('Empleado: ${event.employeeId}'),
            if (event.metadata != null) Text('Detalles: ${event.metadata}'),
            Text(
              DateFormat('dd/MM/yyyy HH:mm:ss').format(event.createdAt),
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }

  Color _getEventColor(String eventType) {
    if (eventType.contains('login')) return Colors.blue;
    if (eventType.contains('clock')) return Colors.green;
    if (eventType.contains('break')) return Colors.orange;
    if (eventType.contains('employee')) return Colors.purple;
    if (eventType.contains('sale')) return Colors.teal;
    return Colors.grey;
  }

  IconData _getEventIcon(String eventType) {
    if (eventType.contains('login')) return Icons.login;
    if (eventType.contains('logout')) return Icons.logout;
    if (eventType.contains('clock_in')) return Icons.access_time;
    if (eventType.contains('clock_out')) return Icons.access_time_filled;
    if (eventType.contains('break')) return Icons.coffee;
    if (eventType.contains('employee')) return Icons.person;
    if (eventType.contains('sale')) return Icons.shopping_cart;
    return Icons.event;
  }

  String _formatEventType(String eventType) {
    return eventType.split('_').map((word) => word[0].toUpperCase() + word.substring(1)).join(' ');
  }
}
