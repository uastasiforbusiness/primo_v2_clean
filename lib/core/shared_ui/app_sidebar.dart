import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:primo_v2/features/auth/presentation/bloc/auth_event.dart';

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
      width: 280,
      margin: const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(180),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withAlpha(100), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(20),
                  blurRadius: 30,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final bool active = item.routeName == 'dashboard'
                          ? (currentRoute == '/dashboard')
                          : currentRoute.contains(item.routeName);
                      return _buildSidebarItem(context, item, active);
                    },
                  ),
                ),
                _buildFooter(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSidebarItem(BuildContext context, SidebarItem item, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2.0),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.goNamed(item.routeName),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected ? Colors.blue.withAlpha(20) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(item.icon, size: 22, color: isSelected ? Colors.blue[700] : Colors.grey[500]),
                const SizedBox(width: 16),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 14,
                    color: isSelected ? Colors.blue[700] : Colors.grey[600],
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
              ],
            ),
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
          const Divider(height: 1, indent: 8, endIndent: 8),
          const SizedBox(height: 8),
          _buildSidebarItem(
            context,
            SidebarItem(
              icon: Icons.settings_outlined,
              label: 'Configuraciones',
              routeName: 'settings',
            ),
            currentRoute.contains('settings'),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: InkWell(
              onTap: () => context.read<AuthBloc>().add(const LogoutRequested()),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    const Icon(Icons.logout, size: 22, color: Colors.redAccent),
                    const SizedBox(width: 16),
                    Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent[700],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
