import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SidebarItem {
  final IconData icon;
  final String label;
  final String routeName;

  SidebarItem({
    required this.icon,
    required this.label,
    required this.routeName,
  });
}

class AppSidebar extends StatelessWidget {
  final String currentRoute;

  const AppSidebar({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      SidebarItem(icon: Icons.dashboard_outlined, label: 'Dashboard', routeName: 'dashboard'),
      SidebarItem(icon: Icons.shopping_cart_outlined, label: 'Venta', routeName: 'active-shift'),
      SidebarItem(icon: Icons.inventory_2_outlined, label: 'Inventario', routeName: 'inventory'),
      SidebarItem(icon: Icons.people_outline, label: 'Empleados', routeName: 'employees'),
      SidebarItem(icon: Icons.assignment_outlined, label: 'Auditoría', routeName: 'audit'),
      SidebarItem(icon: Icons.bar_chart_outlined, label: 'Reportes', routeName: 'reports'),
    ];

    return Container(
      width: 250,
      color: Colors.white,
      child: Column(
        children: [
          _buildHeader(context),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = currentRoute.contains(item.routeName);
                return _buildSidebarItem(context, item, isSelected);
              },
            ),
          ),
          _buildFooter(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 24,
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Usuario',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'Cajero ID: #001',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, SidebarItem item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: InkWell(
        onTap: () => context.goNamed(item.routeName),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Icon(
                item.icon,
                color: isSelected ? Colors.blue : Colors.grey[600],
              ),
              const SizedBox(width: 16),
              Text(
                item.label,
                style: TextStyle(
                  color: isSelected ? Colors.blue : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          _buildSidebarItem(
            context,
            SidebarItem(icon: Icons.settings_outlined, label: 'Configuraciones', routeName: 'settings'),
            currentRoute.contains('settings'),
          ),
          _buildSidebarItem(
            context,
            SidebarItem(icon: Icons.logout, label: 'Logout', routeName: 'login'),
            false,
          ),
        ],
      ),
    );
  }
}
