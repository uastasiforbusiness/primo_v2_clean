import 'package:flutter/material.dart';

import 'app_background.dart';
import 'app_header.dart'; // Importamos el nuevo header
import 'app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  String _getRouteTitle(String route) {
    if (route.contains('dashboard')) return 'Dashboard';
    if (route.contains('active-shift')) return 'Venta';
    if (route.contains('inventory')) return 'Inventario';
    if (route.contains('employees')) return 'Empleados';
    if (route.contains('audit')) return 'Auditoría';
    if (route.contains('reports')) return 'Reportes';
    if (route.contains('settings')) return 'Configuraciones';
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Row(
          children: [
            AppSidebar(currentRoute: currentRoute),
            const VerticalDivider(width: 1, thickness: 1, color: Colors.black12),
            Expanded(
              child: Column(
                children: [
                  AppHeader(title: _getRouteTitle(currentRoute)),
                  Expanded(child: child),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
