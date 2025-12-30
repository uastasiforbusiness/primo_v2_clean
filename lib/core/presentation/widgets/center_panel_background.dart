import 'package:flutter/material.dart';

/// Wraps a widget with a subtle centered background image.
///
/// Intended to constrain background branding (e.g. a logo) to a specific panel
/// rather than the entire screen.
class CenterPanelBackground extends StatelessWidget {
  const CenterPanelBackground({
    super.key,
    required this.child,
    required this.imageAsset,
    this.opacity = 0.25,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.center,
  });

  final Widget child;
  final String imageAsset;
  final double opacity;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        IgnorePointer(
          child: Opacity(
            opacity: opacity,
            child: Image.asset(
              imageAsset,
              fit: fit,
              alignment: alignment,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
