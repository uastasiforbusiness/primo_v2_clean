import 'package:flutter/material.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  final EmployeeEntity employee;

  const DashboardPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    // Limpiamos el dashboard y dejamos que AppScaffold maneje el fondo global
    return const AppScaffold(
      body: SizedBox.expand(), // Dashboard vacío, solo el fondo que tanto te gusta
    );
  }
}
