import 'package:flutter/material.dart';

class AppBackground extends StatelessWidget {
  final Widget? child;
  final String imagePath;
  final double opacity;
  final BoxFit fit;
  final Alignment alignment;

  const AppBackground({
    super.key,
    this.child,
    this.imagePath = 'assets/images/background.png',
    this.opacity = 0.3,
    this.fit = BoxFit.cover, // Cambiado a cover para que sea el doble de grande
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Capa de fondo
        Positioned.fill(
          child: Container(
            color: Colors.white,
            child: Opacity(
              opacity: opacity,
              child: Image.asset(
                imagePath,
                fit: fit,
                alignment: alignment,
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
