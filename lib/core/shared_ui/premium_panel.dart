import 'dart:ui';
import 'package:flutter/material.dart';

class PremiumPanel extends StatelessWidget {
  final Widget child;
  final double width;
  final bool isVisible;

  const PremiumPanel({
    super.key,
    required this.child,
    this.width = 400,
    this.isVisible = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: isVisible ? width : 0,
      margin: isVisible
          ? const EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 20)
          : EdgeInsets.zero,
      child: isVisible
          ? ClipRRect(
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
                        color: Colors.black.withAlpha(15),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: child,
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
