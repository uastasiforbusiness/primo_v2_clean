import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../shifts/presentation/bloc/shift_bloc.dart';
import '../../../shifts/presentation/bloc/shift_event.dart';
import '../../domain/entities/employee_entity.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';

class ClockInPage extends StatefulWidget {
  final EmployeeEntity employee;

  const ClockInPage({
    super.key,
    required this.employee,
  });

  @override
  State<ClockInPage> createState() => _ClockInPageState();
}

class _ClockInPageState extends State<ClockInPage> {
  final _formKey = GlobalKey<FormState>();
  final _initialCashController = TextEditingController();

  @override
  void dispose() {
    _initialCashController.dispose();
    super.dispose();
  }

  void _handleClockIn() {
    if (_formKey.currentState!.validate()) {
      final initialCash = double.tryParse(_initialCashController.text) ?? 0.0;
      context.read<ShiftBloc>().add(
            ClockInRequested(
              employeeId: widget.employee.id,
              initialCash: initialCash,
            ),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iniciar Turno'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Icon(Icons.waving_hand,
                        size: 64, color: Colors.deepPurple),
                    const SizedBox(height: 16),
                    Text(
                      '¡Bienvenido!',
                      textAlign: TextAlign.center,
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.employee.fullName,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.deepPurple,
                          ),
                    ),
                    const SizedBox(height: 32),
                    TextFormField(
                      controller: _initialCashController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Fondo de Caja Inicial',
                        hintText: '0.00',
                        prefixText: '\$ ',
                        border: OutlineInputBorder(),
                        helperText: 'Ingresa el dinero inicial en la caja',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Este campo es obligatorio';
                        }
                        final amount = double.tryParse(value);
                        if (amount == null) {
                          return 'Ingresa un monto válido';
                        }
                        if (amount < 0) {
                          return 'El monto no puede ser negativo';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: _handleClockIn,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Iniciar Turno',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () {
                        context.read<AuthBloc>().add(const LogoutRequested());
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancelar'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
