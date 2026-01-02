import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_kernel/role.dart';
import '../../../../core/shared_ui/app_scaffold.dart';
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<EmployeeBloc>()..add(const LoadEmployees()),
      child: AppScaffold(
        showBackground: false,
        body: BlocBuilder<EmployeeBloc, EmployeeState>(
          builder: (context, state) {
            if (state is EmployeeLoading) {
              return const Center(child: CircularProgressIndicator(strokeWidth: 2));
            }

            if (state is EmployeeError) {
              return Center(child: Text(state.message));
            }

            if (state is EmployeeLoaded) {
              final employees = state.employees;

              return Row(
                children: [
                  // Columna 2: Lista de Empleados
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _onStartCreating,
                            icon: const Icon(Icons.add, size: 18),
                            label: const Text('NUEVO EMPLEADO'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Expanded(
                            child: SingleChildScrollView(
                              child: Wrap(
                                spacing: 24,
                                runSpacing: 24,
                                children: employees.map((employee) {
                                  final isSelected = _selectedEmployee?.id == employee.id;
                                  return SizedBox(
                                    width: 160,
                                    height: 160,
                                    child: _ModernEmployeeCard(
                                      employee: employee,
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

                  if (_selectedEmployee != null || _isCreating) ...[
                    const VerticalDivider(width: 1, thickness: 1, color: Colors.black12),
                    // Columna 3: Detalles o Formulario (Ancho fijo)
                    Container(
                      width: 400,
                      color: Colors.white.withAlpha(150),
                      child: _buildRightPanel(context),
                    ),
                  ],
                ],
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildRightPanel(BuildContext context) {
    if (_isCreating) {
      return _EmployeeForm(
        onCancel: _onCancel,
        onSave: (employee, pin) {
          context.read<EmployeeBloc>().add(
                CreateEmployeeRequested(
                  employee: employee,
                  pin: pin,
                ),
              );
          _onCancel();
        },
      );
    }

    if (_selectedEmployee != null) {
      return _EmployeeDetails(
        employee: _selectedEmployee!,
        onClose: _onCancel,
        onDelete: (id) {
          context.read<EmployeeBloc>().add(DeleteEmployeeRequested(id));
          _onCancel();
        },
      );
    }

    return const SizedBox.shrink();
  }
}

class _ModernEmployeeCard extends StatelessWidget {
  final EmployeeEntity employee;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModernEmployeeCard({
    required this.employee,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final initials = employee.name[0].toUpperCase() +
        (employee.lastName.isNotEmpty ? employee.lastName[0].toUpperCase() : '');

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue[50] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected ? Colors.blue[300]! : Colors.black.withAlpha(15),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(5),
                blurRadius: 15,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            children: [
              Positioned(
                top: 16,
                right: 16,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: employee.isActive ? Colors.greenAccent[700] : Colors.grey[400],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue[400]!, Colors.blue[700]!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      employee.fullName.toUpperCase(),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isSelected ? Colors.blue[900] : Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.blue[100] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        employee.role.toValue(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: isSelected ? Colors.blue[700] : Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmployeeDetails extends StatelessWidget {
  final EmployeeEntity employee;
  final VoidCallback onClose;
  final Function(String) onDelete;

  const _EmployeeDetails({
    required this.employee,
    required this.onClose,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'DETALLES',
                style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 12),
              ),
              IconButton(onPressed: onClose, icon: const Icon(Icons.close, size: 20)),
            ],
          ),
          const SizedBox(height: 40),
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
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Center(
            child: Text(
              employee.role.toValue(),
              style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 40),
          _buildInfoTile(Icons.email_outlined, 'Email', employee.email ?? '-'),
          _buildInfoTile(Icons.phone_outlined, 'Teléfono', employee.phone ?? '-'),
          _buildInfoTile(Icons.emergency_outlined, 'Emergencia', employee.emergencyPhone),
          const Spacer(),
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
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.black26),
          const SizedBox(width: 16),
          Column(
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
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmployeeForm extends StatefulWidget {
  final VoidCallback onCancel;
  final Function(EmployeeEntity, String) onSave;

  const _EmployeeForm({required this.onCancel, required this.onSave});

  @override
  State<_EmployeeForm> createState() => _EmployeeFormState();
}

class _EmployeeFormState extends State<_EmployeeForm> {
  final _id = const Uuid().v4();
  final _nameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emergencyController = TextEditingController();
  final _pinController = TextEditingController();
  Role _selectedRole = Role.staff;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'NUEVO EMPLEADO',
              style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5, fontSize: 12),
            ),
            const SizedBox(height: 32),
            _buildTextField('Nombre', _nameController),
            const SizedBox(height: 16),
            _buildTextField('Apellido', _lastNameController),
            const SizedBox(height: 16),
            const Text(
              'Rol',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<Role>(
              initialValue: _selectedRole,
              items: [
                DropdownMenuItem(value: Role.admin, child: Text(Role.admin.toValue())),
                DropdownMenuItem(value: Role.supervisor, child: Text(Role.supervisor.toValue())),
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
            _buildTextField('Email (Opcional)', _emailController),
            const SizedBox(height: 16),
            _buildTextField('Teléfono', _phoneController),
            const SizedBox(height: 16),
            _buildTextField('PIN (4 dígitos)', _pinController, isObscure: true),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: TextButton(onPressed: widget.onCancel, child: const Text('CANCELAR')),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      final employee = EmployeeEntity(
                        id: _id,
                        name: _nameController.text,
                        lastName: _lastNameController.text,
                        email: _emailController.text.isNotEmpty ? _emailController.text : null,
                        phone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
                        emergencyPhone: _emergencyController.text,
                        role: _selectedRole,
                        isActive: true,
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
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

  Widget _buildTextField(String label, TextEditingController controller, {bool isObscure = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: isObscure,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }
}
