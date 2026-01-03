import 'package:flutter/material.dart';

import '../../../../core/shared_ui/app_scaffold.dart';
import '../../../../core/shared_ui/premium_button.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      showBackground: false,
      appBar: AppBar(
        title: const Text(
          'AUDITORÍA DE EVENTOS',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: Colors.black45,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                PremiumButton(
                  label: 'Empleados',
                  icon: Icons.people_outline,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                PremiumButton(
                  label: 'Inventario',
                  icon: Icons.inventory_2_outlined,
                  onPressed: () {},
                ),
                const SizedBox(width: 16),
                PremiumButton(
                  label: 'Venta',
                  icon: Icons.shopping_cart_outlined,
                  onPressed: () {},
                ),
              ],
            ),
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.assignment_outlined,
                      size: 64,
                      color: Colors.black12,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'HISTORIAL DE AUDITORÍA',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 2,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Próximamente',
                      style: TextStyle(
                        color: Colors.black26,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
