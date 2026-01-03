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
    });
  }

  void _onStartCreating() {
    setState(() {
      _selectedEmployee = null;
      _isCreating = true;
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

  Future<void> _showErrorDialog(BuildContext context, String message) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeeBloc>()..add(const LoadEmployees()),
      child: BlocListener<EmployeeBloc, EmployeeState>(
        listener: (context, state) async {
          if (state is EmployeeError) {
            await _showErrorDialog(context, state.message);
          }
          if (state is EmployeeOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.greenAccent[700],
                behavior: SnackBarBehavior.floating,
                margin: const EdgeInsets.all(20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }
        },
        child: AppScaffold(
          showBackground: false,
          body: BlocBuilder<EmployeeBloc, EmployeeState>(
            builder: (context, state) {
              if (state is EmployeeLoading && _employees.isEmpty) {
                return const Center(child: CircularProgressIndicator(strokeWidth: 2));
              }

              if (state is EmployeeLoaded) {
                _employees = state.employees;
              }

              if (state is EmployeeError && _employees.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline, size: 48, color: Colors.redAccent),
                      const SizedBox(height: 16),
                      Text(state.message),
                      TextButton(
                        onPressed: () => context.read<EmployeeBloc>().add(const LoadEmployees()),
                        child: const Text('REINTENTAR'),
                      ),
                    ],
                  ),
                );
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
                                  final initials = employee.name[0].toUpperCase() +
                                      (employee.lastName.isNotEmpty
                                          ? employee.lastName[0].toUpperCase()
                                          : '');
                                  return SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: PremiumCard(
                                      title: employee.fullName,
                                      subtitle: employee.role.toValue(),
                                      avatarText: initials,
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
                  ),
                );
          } else {
            context.read<EmployeeBloc>().add(
                  CreateEmployeeRequested(
                    employee: employee,
                    pin: pin,
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
          context.read<EmployeeBloc>().add(DeleteEmployeeRequested(id));
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
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(24.0), // Reduced from 32
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Text(
                      'DETALLES DE EMPLEADO',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 10,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: onClose,
                    icon: const Icon(Icons.close, size: 20),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Center(
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              employee.name[0],
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Center(
                        child: Text(
                          employee.fullName,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Center(
                        child: Text(
                          employee.role.toValue(),
                          style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(height: 32),
                      _buildInfoTile(Icons.email_outlined, 'Email', employee.email ?? '-'),
                      _buildInfoTile(Icons.phone_outlined, 'Teléfono', employee.phone ?? '-'),
                      _buildInfoTile(
                        Icons.emergency_outlined,
                        'Emergencia',
                        employee.emergencyPhone,
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 18),
                      label: const Text('EDITAR EMPLEADO'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () => onDelete(employee.id),
                      icon: const Icon(Icons.delete_outline, size: 18),
                      label: const Text('ELIMINAR EMPLEADO'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black26),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black38,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
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

  const _EmployeeForm({
    this.employee,
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  final _formKey = GlobalKey<FormState>();
  late String _id;
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _hourlyRateController = TextEditingController();
  final _pinController = TextEditingController();
  late Role _selectedRole;

  @override
  void initState() {
    super.initState();
    if (widget.employee != null) {
      _id = widget.employee!.id;
      _nameController.text = widget.employee!.name;
      _lastNameController.text = widget.employee!.lastName;
      _emailController.text = widget.employee!.email ?? '';
      _phoneController.text = widget.employee!.phone ?? '';
      _emergencyController.text = widget.employee!.emergencyPhone;
      _hourlyRateController.text = widget.employee!.hourlyRate?.toString() ?? '';
      _selectedRole = widget.employee!.role;
      _pinController.text = '';
    } else {
      _id = const Uuid().v4();
      _selectedRole = Role.staff;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(24.0), // Reduced from 32
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.employee != null ? 'EDITAR EMPLEADO' : 'NUEVO EMPLEADO',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildTextField('Nombre', _nameController, validator: (v) => _validateField(v, 'Nombre')),
                    const SizedBox(height: 16),
                    _buildTextField('Apellido', _lastNameController, validator: (v) => _validateField(v, 'Apellido')),
                    const SizedBox(height: 16),
                    const Text(
                      'Rol',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<Role>(
                      initialValue: _selectedRole,
                      items: [
                        DropdownMenuItem(value: Role.admin, child: Text(Role.admin.toValue())),
                        DropdownMenuItem(
                          value: Role.supervisor,
                          child: Text(Role.supervisor.toValue()),
                        ),
                        DropdownMenuItem(value: Role.staff, child: Text(Role.staff.toValue())),
                        DropdownMenuItem(value: Role.kitchen, child: Text(Role.kitchen.toValue())),
                      ],
                      onChanged: (val) => setState(() => _selectedRole = val!),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[50],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField('Email (Opcional)', _emailController, validator: _validateEmail),
                    const SizedBox(height: 16),
                    _buildTextField('Teléfono', _phoneController, validator: _validatePhone),
                    const SizedBox(height: 16),
                    _buildTextField('Teléfono de Emergencia', _emergencyController,
                      validator: (v) => _validateField(v, 'Teléfono de Emergencia'),
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      'Salario por Hora (Opcional)',
                      _hourlyRateController,
                      isNumber: true,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      widget.employee != null ? 'Nuevo PIN (Opcional)' : 'PIN (4 dígitos)',
                      _pinController,
                      isObscure: true,
                      validator: widget.employee != null ? null : _validatePin,
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: widget.onCancel,
                    child: const Text('CANCELAR', style: TextStyle(fontSize: 12)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) {
                        return;
                      }
                      final employee = EmployeeEntity(
                        id: _id,
                        name: _nameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text.isNotEmpty ? _emailController.text : null,
                        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                        emergencyPhone: _emergencyController.text,
                        hourlyRate: double.tryParse(_hourlyRateController.text),
                        role: _selectedRole,
                        isActive: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        securityVersion:1,
                      );
                      widget.onSave(employee, _pinController.text);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[700],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    child: const Text('GUARDAR', style: TextStyle(fontSize: 12)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String? _validateField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es requerido';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Email inválido';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }
    final phoneRegex = RegExp(r'^[\d\s\+\-\(\)]{8,20}$');
    if (!phoneRegex.hasMatch(value)) {
      return 'Teléfono inválido';
    }
    return null;
  }

  String? _validatePin(String? value) {
    final pinRegex = RegExp(r'^\d{4}$');
    if (value == null || value.isEmpty) {
      return 'PIN es requerido';
    }
    if (!pinRegex.hasMatch(value)) {
      return 'PIN debe ser 4 dígitos numéricos';
    }
    return null;
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isObscure = false,
    bool isNumber = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: isObscure,
          keyboardType: isNumber ? const TextInputType.numberWithOptions(decimal: true) : null,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.red, width: 1),
            ),
            errorStyle: const TextStyle(fontSize: 10, color: Colors.red),
          ),
        ),
      ],
    );
  }
}
