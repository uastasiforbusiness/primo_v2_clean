import 'package:flutter/material.dart';
import '../../../../core/shared_ui/app_scaffold.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      showBackground: false, // El fondo ya lo pone MainLayout
      body: Center(
        child: Text(
          'Sección Empleados (Limpia)',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }
}
