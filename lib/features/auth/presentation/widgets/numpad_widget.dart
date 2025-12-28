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
      constraints: const BoxConstraints(maxWidth: 300),
      child: Column(
        children: [
          _buildRow(['1', '2', '3']),
          const SizedBox(height: 12),
          _buildRow(['4', '5', '6']),
          const SizedBox(height: 12),
          _buildRow(['7', '8', '9']),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildButton(
                child: const Icon(Icons.clear),
                onPressed: onClearPressed,
              ),
              _buildButton(
                child: const Text(
                  '0',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                onPressed: () => onNumberPressed('0'),
              ),
              _buildButton(
                child: const Icon(Icons.backspace_outlined),
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
      children: numbers
          .map((number) => _buildButton(
                child: Text(
                  number,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                onPressed: () => onNumberPressed(number),
              ))
          .toList(),
    );
  }

  Widget _buildButton({
    required Widget child,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: 70,
      height: 70,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 2,
        ),
        child: child,
      ),
    );
  }
}
