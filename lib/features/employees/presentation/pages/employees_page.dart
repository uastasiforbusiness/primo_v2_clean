import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:primo_v2/core/entities/employee_entity.dart';
import 'package:primo_v2/core/presentation/widgets/app_scaffold.dart';
import 'package:primo_v2/core/shared_kernel/role.dart';

import '../../../../di/injection_container.dart';
import '../bloc/employee_bloc.dart';
import '../bloc/employee_event.dart' as employee_event;
import '../bloc/employee_state.dart';
import '../widgets/employee_form_dialog.dart';

class EmployeesPage extends StatelessWidget {
  const EmployeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<EmployeeBloc>()..add(const employee_event.LoadEmployees()),
      child: const _EmployeesView(),
    );
  }
}

class _EmployeesView extends StatefulWidget {
  const _EmployeesView();

  @override
  State<_EmployeesView> createState() => _EmployeesViewState();
}

class _EmployeesViewState extends State<_EmployeesView> {
  EmployeeEntity? _selectedEmployee;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Row(
        children: [
          // Main Section (Table)
          Expanded(
            flex: 3,
            child: _buildMainSection(context),
          ),
          // Quick View Panel on the right
          _buildQuickViewPanel(context),
        ],
      ),
    );
  }

  Widget _buildMainSection(BuildContext context) {
    return Container(
      color: Colors.grey[50]?.withAlpha(128),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopBar(context),
          Expanded(
            child: _buildEmployeeGrid(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(5),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search employees by name, role or ID...',
                  hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400], size: 20),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          Row(
            children: [
              Text(
                DateFormat('MMM dd, yyyy • hh:mm a').format(DateTime.now()),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(5),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child:
                    const Icon(Icons.notifications_none_rounded, size: 20, color: Colors.black87),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmployeeGrid(BuildContext context) {
    return BlocBuilder<EmployeeBloc, EmployeeState>(
      builder: (context, state) {
        if (state is EmployeeLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is EmployeeLoaded) {
          final employees = state.employees;
          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              mainAxisExtent: 360,
              crossAxisSpacing: 24,
              mainAxisSpacing: 24,
            ),
            itemCount: employees.length + 1,
            itemBuilder: (context, index) {
              if (index == employees.length) {
                return _buildAddStaffCard(context);
              }
              return _buildEmployeeCard(context, employees[index]);
            },
          );
        }

        return const SizedBox();
      },
    );
  }

  Widget _buildEmployeeCard(BuildContext context, EmployeeEntity employee) {
    final isSelected = _selectedEmployee?.id == employee.id;
    final roleColor = _getRoleColor(employee.role);

    return InkWell(
      onTap: () => setState(() => _selectedEmployee = employee),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isSelected ? Border.all(color: Colors.blue.withAlpha(100), width: 2) : null,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(isSelected ? 15 : 5),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Card Header (Role Badge & Menu)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: roleColor.withAlpha(20),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            color: roleColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          employee.role.toValue().toUpperCase(),
                          style: TextStyle(
                            color: roleColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.more_horiz, color: Colors.grey, size: 20),
                ],
              ),
            ),
            // Avatar & Name
            const SizedBox(height: 8),
            CircleAvatar(
              radius: 42,
              backgroundColor: Colors.grey[100],
              child: Text(
                employee.name[0],
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              employee.fullName,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            Text(
              employee.role.toValue(),
              style: TextStyle(fontSize: 14, color: Colors.grey[500], fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 24),
            // Stats Section
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSmallStatColumn('Daily Goal', '\$1k'),
                  ),
                  Container(width: 1, height: 30, color: Colors.grey[100]),
                  Expanded(
                    child: _buildSmallStatColumn('Sales', '\$482.50'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey[50]!)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.circle, color: Colors.green, size: 8),
                      const SizedBox(width: 8),
                      Text(
                        'ONLINE',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: const Text(
                      'EDIT',
                      style:
                          TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSmallStatColumn(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
        ),
      ],
    );
  }

  Widget _buildAddStaffCard(BuildContext context) {
    return InkWell(
      onTap: () => _showEmployeeDialog(context),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey[300]!, width: 2, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withAlpha(10),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add, color: Colors.blue, size: 32),
            ),
            const SizedBox(height: 16),
            const Text(
              'ADD NEW STAFF',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRoleColor(Role role) {
    if (role == Role.admin) return Colors.blue;
    if (role == Role.supervisor) return Colors.purple;
    if (role == Role.staff) return Colors.orange;
    if (role == Role.kitchen) return Colors.teal;
    return Colors.grey;
  }

  Widget _buildEmptyQuickView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person_search_outlined, size: 64, color: Colors.grey[300]),
        ),
        const SizedBox(height: 24),
        const Text(
          'Quick View',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
        ),
        const SizedBox(height: 8),
        Text(
          'Select an employee\nto see detailed information',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey[500], fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildEmployeeDetails(EmployeeEntity employee) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick View',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              onPressed: () => setState(() => _selectedEmployee = null),
              icon: const Icon(Icons.close),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Center(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[100],
                child: Icon(Icons.person_outline, size: 50, color: Colors.grey[400]),
              ),
              const SizedBox(height: 16),
              Text(
                employee.fullName,
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              Text(
                employee.role.toValue(),
                style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildActionIcon(Icons.email_outlined),
                  const SizedBox(width: 12),
                  _buildActionIcon(Icons.call_outlined),
                  const SizedBox(width: 12),
                  _buildActionIcon(Icons.edit_outlined),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 40),
        _buildDetailSection('CURRENT SHIFT', 'On Time'),
        _buildShiftProgress('4h 30m worked', 'Started 06:15 AM', 0.6),
        const SizedBox(height: 24),
        _buildSalesCard('Sales Today', '42 Transactions', '\$482.50'),
        const SizedBox(height: 24),
        _buildScheduleSection(),
        const SizedBox(height: 40),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: const Text('MANAGE SCHEDULE'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActionIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(13),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: Colors.blue),
    );
  }

  Widget _buildDetailSection(String title, String status) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold),
        ),
        Text(
          status,
          style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildShiftProgress(String left, String right, double progress) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(left, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(right, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[200],
          valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          borderRadius: BorderRadius.circular(4),
          minHeight: 6,
        ),
      ],
    );
  }

  Widget _buildQuickViewPanel(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(left: BorderSide(color: Colors.grey[100]!)),
      ),
      child: _selectedEmployee == null
          ? _buildEmptyQuickView()
          : _buildEmployeeDetails(_selectedEmployee!),
    );
  }

  Widget _buildSalesCard(String title, String subtitle, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withAlpha(25),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: Colors.orange, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 11)),
              ],
            ),
          ),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildScheduleSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upcoming Schedule',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        _buildScheduleItem('25', 'TOMORROW', 'Morning Shift', '06:00 AM - 02:00 PM'),
        const SizedBox(height: 12),
        _buildScheduleItem('26', 'THU', 'Off Day', 'Rest'),
      ],
    );
  }

  Widget _buildScheduleItem(String day, String dayLabel, String shift, String time) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                dayLabel,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(day, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(width: 16),
          Container(width: 1, height: 30, color: Colors.grey[200]),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(shift, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text(time, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showEmployeeDialog(BuildContext parentContext) async {
    await showDialog(
      context: parentContext,
      builder: (context) {
        return EmployeeFormDialog(
          onSave: (employee, pin) {
            parentContext.read<EmployeeBloc>().add(
                  employee_event.CreateEmployeeRequested(
                    employee: employee,
                    pin: pin!,
                  ),
                );
          },
        );
      },
    );
  }
}
