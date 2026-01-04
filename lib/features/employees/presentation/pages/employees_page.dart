import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_kernel/role.dart';
import '../../../../core/shared_ui/app_scaffold.dart';
import '../../../../core/shared_ui/premium_button.dart';
import '../../../../core/shared_ui/premium_card.dart';
import '../../../../core/shared_ui/premium_panel.dart';
import '../../../../di/injection_container.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_state.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart';
import '../bloc/employee_state.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  EmployeeEntity? _selectedEmployee;
  bool _isCreating = false;
  bool _isEditing = false;
  List<EmployeeEntity> _employees = [];

  void _onEmployeeSelected(EmployeeEntity employee) {
    setState(() {
      _selectedEmployee = employee;
      _isCreating = false;
      _isEditing = false;
    });
  }

  void _onStartCreating() {
    setState(() {
      _selectedEmployee = null;
      _isCreating = true;
      _isEditing = false;
    });
  }

  void _onCancel() {
    setState(() {
      _selectedEmployee = null;
      _isCreating = false;
      _isEditing = false;
    });
  }

  void _onStartEditing(EmployeeEntity employee) {
    setState(() {
      _selectedEmployee = employee;
      _isCreating = false;
      _isEditing = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeeBloc>()..add(const LoadEmployees()),
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) {
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green),
            );
          }
        },
        child: AppScaffold(
          showBackground: false,
          body: BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, state) {
              if (state is EmployeeLoading && _employees.isEmpty) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is EmployeeLoaded) {
                _employees = state.employees;
              }

              return Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          PremiumButton(
                            onPressed: _onStartCreating,
                            icon: Icons.add,
                            label: 'NUEVO EMPLEADO',
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 24,
                                runSpacing: 24,
                                children: _employees.map((employee) {
                                  final isSelected = _selectedEmployee?.id == employee.id;
                                  return SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: PremiumCard(
                                      title: employee.fullName,
                                      subtitle: employee.role.toValue(),
                                      avatarText: employee.name[0],
                                      isActive: employee.isActive,
                                      isSelected: isSelected,
                                      onTap: () => _onEmployeeSelected(employee),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PremiumPanel(
                    isVisible: _selectedEmployee != null || _isCreating,
                    width: 320,
                    child: _buildRightPanel(context),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    // AQUÍ CAPTURAMOS AL ACTOR (Quien está usando la app)
    final authState = context.read<AuthBloc>().state;
    final String actorId =
        (authState is AuthAuthenticated) ? authState.employee.id : 'system-admin';

    if (_isCreating || _isEditing) {
      return _EmployeeForm(
        employee: _isEditing ? _selectedEmployee : null,
        onCancel: _onCancel,
        onSave: (employee, pin) {
          if (_isEditing) {
            context.read<EmployeeBloc>().add(
                  UpdateEmployeeRequested(
                    employee: employee,
                    newPin: pin.isNotEmpty ? pin : null,
                    actorId: actorId, // Inyectamos responsable
                  ),
                );
          } else {
            context.read<EmployeeBloc>().add(
                  CreateEmployeeRequested(
                    employee: employee,
                    pin: pin,
                    actorId: actorId, // Inyectamos responsable
                  ),
                );
          }
          _onCancel();
        },
      );
    }

    if (_selectedEmployee != null) {
      return _EmployeeDetails(
        employee: _selectedEmployee!,
        onClose: _onCancel,
        onEdit: () => _onStartEditing(_selectedEmployee!),
        onDelete: (id) {
          context.read<EmployeeBloc>().add(
                DeleteEmployeeRequested(id, actorId: actorId), // Inyectamos responsable
              );
          _onCancel();
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _EmployeeDetails extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final Function(String) onDelete;

  const _EmployeeDetails({
    required this.employee,
    required this.onClose,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('DETALLES', style: TextStyle(fontWeight: FontWeight.bold)),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close)),
            ],
          ),
          const SizedBox(height: 20),
          const CircleAvatar(radius: 40, child: Icon(Icons.person, size: 40)),
          const SizedBox(height: 16),
          Text(
            employee.fullName,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(employee.role.toValue(), style: const TextStyle(color: Colors.grey)),
          const Spacer(),
          ElevatedButton(onPressed: onEdit, child: const Text('EDITAR')),
          const SizedBox(height: 8),
          if (employee.id != 'admin-001')
            OutlinedButton(
              onPressed: () => onDelete(employee.id),
              style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('ELIMINAR'),
            ),
        ],
      ),
    );
  }
}

class _EmployeeForm extends StatefulWidget {
  final EmployeeEntity? employee;
  final VoidCallback onCancel;
  final Function(EmployeeEntity, String) onSave;
  const _EmployeeForm({this.employee, required this.onCancel, required this.onSave});

  @override
  State<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _pinController = TextEditingController();
  Role _selectedRole = Role.staff;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _nameController.text = widget.employee!.name;
      _lastNameController.text = widget.employee!.lastName;
      _emergencyController.text = widget.employee!.emergencyPhone;
      _selectedRole = widget.employee!.role;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Text('FORMULARIO', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nombre'),
            ),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(labelText: 'Apellido'),
            ),
            TextFormField(
              controller: _emergencyController,
              decoration: const InputDecoration(labelText: 'Emergencia'),
            ),
            TextFormField(
              controller: _pinController,
              decoration: const InputDecoration(labelText: 'PIN (4 dígitos)'),
            ),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: widget.onCancel, child: const Text('CANCELAR')),
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final emp = EmployeeEntity(
                        id: widget.employee?.id ?? const Uuid().v4(),
                        name: _nameController.text,
                        lastName: _lastNameController.text,
                        emergencyPhone: _emergencyController.text,
                        role: _selectedRole,
                        isActive: true,
                        createdAt: widget.employee?.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now(),
                      );
                      widget.onSave(emp, _pinController.text);
                    },
                    child: const Text('GUARDAR'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
