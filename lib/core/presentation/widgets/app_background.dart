import 'package:flutter/material.dart';

/// Un widget que envuelve el contenido con un fondo de imagen consistente.
/// Esto permite cambiar el fondo de toda la app desde un solo lugar.
class AppBackground extends StatelessWidget {
  final Widget? child;
  final String imagePath;
  final double opacity;

  const AppBackground({
    super.key,
    this.child,
    this.imagePath = 'assets/images/background.png',
    this.opacity = 0.3, // Aumentado para que sea más visible como pidió el usuario
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Capa de fondo
        Positioned.fill(
          child: Container(
            color: Colors.white, // Fondo base blanco
            child: Opacity(
              opacity: opacity,
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        // Contenido
        if (child != null) child!,
      ],
    );
  }
}
