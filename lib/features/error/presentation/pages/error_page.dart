import 'package:flutter/material.dart';

/// ErrorPage - Generic error screen
class ErrorPage extends StatelessWidget {
  final String message;

  const ErrorPage({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Error icon
              Icon(
                Icons.error_outline,
                size: 100,
                color: Colors.red[400],
              ),
              const SizedBox(height: 32),

              // Error title
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.red[800],
                    ),
              ),
              const SizedBox(height: 16),

              // Error message
              Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 32),

              // Try again button
              ElevatedButton(
                onPressed: () {
                  // TODO: Implement retry logic or navigate back
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Intentar de nuevo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}