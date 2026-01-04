import 'package:flutter/material.dart';
import '../../../../core/entities/employee_entity.dart';

class DashboardPage extends StatelessWidget {
  final EmployeeEntity employee;

  const DashboardPage({
    super.key,
    required this.employee,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.expand();
  }
}
