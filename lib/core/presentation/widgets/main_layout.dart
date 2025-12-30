import 'package:flutter/material.dart';

import 'app_background.dart';
import 'app_sidebar.dart';

class MainLayout extends StatelessWidget {
  final Widget child;
  final String currentRoute;

  const MainLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppBackground(
        child: Row(
          children: [
            AppSidebar(currentRoute: currentRoute),
            const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              child: child,
            ),
          ],
        ),
      ),
    );
  }
}
