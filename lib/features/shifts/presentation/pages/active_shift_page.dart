import 'package:flutter/material.dart';
import '../../../../core/shared_ui/app_scaffold.dart';

class ActiveShiftPage extends StatelessWidget {
  const ActiveShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      showBackground: false,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.black12,
            ),
            SizedBox(height: 16),
            Text(
              'MÓDULO DE VENTAS',
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
    );
  }
}
