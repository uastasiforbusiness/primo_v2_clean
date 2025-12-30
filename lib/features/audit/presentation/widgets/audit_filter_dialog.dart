import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/value_objects/audit_filter.dart';

class AuditFilterDialog extends StatefulWidget {
  final AuditFilter? initialFilter;
  final Function(AuditFilter) onApply;

  const AuditFilterDialog({
    super.key,
    this.initialFilter,
    required this.onApply,
  });

  @override
  State<AuditFilterDialog> createState() => _AuditFilterDialogState();
}

class _AuditFilterDialogState extends State<AuditFilterDialog> {
  late TextEditingController eventTypeController;
  late TextEditingController employeeIdController;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    eventTypeController = TextEditingController(
      text: widget.initialFilter?.eventType ?? '',
    );
    employeeIdController = TextEditingController(
      text: widget.initialFilter?.employeeId ?? '',
    );
    startDate = widget.initialFilter?.startDate;
    endDate = widget.initialFilter?.endDate;
  }

  @override
  void dispose() {
    eventTypeController.dispose();
    employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Filtrar Eventos'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filtro por tipo de evento
              TextField(
                controller: eventTypeController,
                decoration: const InputDecoration(
                  labelText: 'Tipo de Evento',
                  hintText: 'ej: login_success, clock_in',
                  border: OutlineInputBorder(),
                  helperText: 'Deja vacío para todos los tipos',
                ),
              ),
              const SizedBox(height: 16),

              // Filtro por empleado
              TextField(
                controller: employeeIdController,
                decoration: const InputDecoration(
                  labelText: 'ID de Empleado',
                  hintText: 'ej: admin-001',
                  border: OutlineInputBorder(),
                  helperText: 'Deja vacío para todos los empleados',
                ),
              ),
              const SizedBox(height: 16),

              // Filtro por fecha de inicio
              const Text(
                'Fecha de Inicio',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectStartDate(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        startDate != null
                            ? DateFormat('dd/MM/yyyy').format(startDate!)
                            : 'Seleccionar fecha',
                      ),
                      const Spacer(),
                      if (startDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => startDate = null),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filtro por fecha de fin
              const Text(
                'Fecha de Fin',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: () => _selectEndDate(context),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 12),
                      Text(
                        endDate != null
                            ? DateFormat('dd/MM/yyyy').format(endDate!)
                            : 'Seleccionar fecha',
                      ),
                      const Spacer(),
                      if (endDate != null)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() => endDate = null),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        TextButton(
          onPressed: _clearFilters,
          child: const Text('Limpiar Todo'),
        ),
        ElevatedButton(
          onPressed: _applyFilters,
          child: const Text('Aplicar'),
        ),
      ],
    );
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => startDate = picked);
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() => endDate = picked);
    }
  }

  void _clearFilters() {
    setState(() {
      eventTypeController.clear();
      employeeIdController.clear();
      startDate = null;
      endDate = null;
    });
  }

  void _applyFilters() {
    final filter = AuditFilter(
      eventType: eventTypeController.text.isEmpty ? null : eventTypeController.text,
      employeeId: employeeIdController.text.isEmpty ? null : employeeIdController.text,
      startDate: startDate,
      endDate: endDate,
    );

    widget.onApply(filter);
    Navigator.pop(context);
  }
}
