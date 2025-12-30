import 'package:flutter/material.dart';

class NumpadWidget extends StatelessWidget {
  final Function(String) onNumberPressed;
  final VoidCallback onBackspacePressed;
  final VoidCallback onClearPressed;

  const NumpadWidget({
    super.key,
    required this.onNumberPressed,
    required this.onBackspacePressed,
    required this.onClearPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxWidth: 320),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 20),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 20),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(
                label: 'Clear',
                onPressed: onClearPressed,
              ),
              _buildNumberButton('0'),
              _buildActionButton(
                icon: Icons.backspace_outlined,
                onPressed: onBackspacePressed,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRow(List<String> numbers) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: numbers.map(_buildNumberButton).toList(),
    );
  }

  Widget _buildNumberButton(String number) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.black.withOpacity(0.1), width: 1),
        color: Colors.white.withOpacity(0.8),
      ),
      child: InkWell(
        onTap: () => onNumberPressed(number),
        customBorder: const CircleBorder(),
        child: Center(
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton({
    String? label,
    IconData? icon,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 80,
      height: 80,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: Center(
          child: label != null
              ? Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black.withOpacity(0.5),
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Icon(
                  icon,
                  color: Colors.black.withOpacity(0.5),
                  size: 24,
                ),
        ),
      ),
    );
  }
}
