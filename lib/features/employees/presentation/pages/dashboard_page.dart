import 'package:flutter/material.dart';
import '../../../../core/entities/employee_entity.dart';
import '../../../../core/shared_ui/app_scaffold.dart';

class DashboardPage extends StatelessWidget {
  final EmployeeEntity employee;

  const DashboardPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      showBackground:
          false, // Desactivamos el fondo del scaffold porque MainLayout ya lo pone en el centro
      body: SizedBox.expand(),
    );
  }
}
