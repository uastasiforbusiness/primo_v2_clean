import 'package:flutter/material.dart';
import 'app_background.dart';

/// Un Scaffold personalizado que incluye automáticamente el fondo de la aplicación.
/// Usar este widget en lugar del Scaffold normal para mantener la consistencia visual.
class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;
  final Widget? drawer;
  final Widget? bottomNavigationBar;
  final Color? backgroundColor;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.floatingActionButton,
    this.drawer,
    this.bottomNavigationBar,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const AppBackground(child: SizedBox.expand()),
        Scaffold(
          appBar: appBar,
          drawer: drawer,
          floatingActionButton: floatingActionButton,
          bottomNavigationBar: bottomNavigationBar,
          backgroundColor: backgroundColor ?? Colors.transparent,
          body: body,
        ),
      ],
    );
  }
}
