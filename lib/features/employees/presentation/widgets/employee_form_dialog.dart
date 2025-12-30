import 'package:flutter/material.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/shared_kernel/role.dart';

class EmployeeFormDialog extends StatefulWidget {
  final EmployeeEntity? employee; // null = crear, not null = editar
  final Function(EmployeeEntity employee, String? pin) onSave;

  const EmployeeFormDialog({
    super.key,
    this.employee,
    required this.onSave,
  });

  @override
  State<EmployeeFormDialog> createState() => _EmployeeFormDialogState();
}

class _EmployeeFormDialogState extends State<EmployeeFormDialog> {
  late final TextEditingController nameController;
  late final TextEditingController lastNameController;
  late final TextEditingController emailController;
  late final TextEditingController phoneController;
  late final TextEditingController emergencyController;
  late final TextEditingController pinController;

  late Role selectedRole;
  bool changingPin = false;

  @override
  void initState() {
    super.initState();

    final employee = widget.employee;

    nameController = TextEditingController(text: employee?.name ?? '');
    lastNameController = TextEditingController(text: employee?.lastName ?? '');
    emailController = TextEditingController(text: employee?.email ?? '');
    phoneController = TextEditingController(text: employee?.phone ?? '');
    emergencyController = TextEditingController(text: employee?.emergencyPhone ?? '');
    pinController = TextEditingController();

    selectedRole = employee?.role ?? Role.staff;
    changingPin = employee == null; // Si es nuevo, siempre requiere PIN
  }

  @override
  void dispose() {
    nameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    emergencyController.dispose();
    pinController.dispose();
    super.dispose();
  }

  bool get isEditing => widget.employee != null;

  void _handleSave() {
    // Validaciones
    if (nameController.text.isEmpty || lastNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y apellido son obligatorios')),
      );
      return;
    }

    if (emergencyController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Teléfono de emergencia es obligatorio')),
      );
      return;
    }

    if (changingPin && pinController.text.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El PIN debe tener 4 dígitos')),
      );
      return;
    }

    final employee = EmployeeEntity(
      id: widget.employee?.id ?? const Uuid().v4(),
      name: nameController.text,
      lastName: lastNameController.text,
      email: emailController.text.isEmpty ? null : emailController.text,
      phone: phoneController.text.isEmpty ? null : phoneController.text,
      emergencyPhone: emergencyController.text,
      role: selectedRole,
      isActive: widget.employee?.isActive ?? true,
      createdAt: widget.employee?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    widget.onSave(employee, changingPin ? pinController.text : null);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEditing ? 'Editar Empleado' : 'Nuevo Empleado'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Apellido *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono (opcional)',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emergencyController,
                decoration: const InputDecoration(
                  labelText: 'Teléfono de Emergencia *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<Role>(
                initialValue: selectedRole,
                items: const [
                  DropdownMenuItem(value: Role.admin, child: Text('Admin')),
                  DropdownMenuItem(value: Role.staff, child: Text('Staff')),
                  DropdownMenuItem(value: Role.kitchen, child: Text('Cocina')),
                  DropdownMenuItem(value: Role.supervisor, child: Text('Supervisor')),
                ],
                onChanged: (val) => setState(() => selectedRole = val!),
                decoration: const InputDecoration(
                  labelText: 'Rol',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              // PIN Section
              if (isEditing)
                CheckboxListTile(
                  title: const Text('Cambiar PIN'),
                  value: changingPin,
                  onChanged: (val) => setState(() => changingPin = val!),
                ),
              if (changingPin) ...[
                const SizedBox(height: 8),
                TextField(
                  controller: pinController,
                  decoration: const InputDecoration(
                    labelText: 'PIN de Acceso (4 dígitos)',
                    helperText: 'Debe ser único en el sistema',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  obscureText: true,
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
        ElevatedButton(
          onPressed: _handleSave,
          child: Text(isEditing ? 'Actualizar' : 'Guardar'),
        ),
      ],
    );
  }
}
