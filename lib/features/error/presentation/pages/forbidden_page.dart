import 'package:flutter/material.dart';

/// ForbiddenPage - Access denied screen
class ForbiddenPage extends StatelessWidget {
  const ForbiddenPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Forbidden icon
              Icon(
                Icons.lock_outline,
                size: 100,
                color: Colors.orange[400],
              ),
              const SizedBox(height: 32),

              // Forbidden title
              Text(
                'Acceso Denegado',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[800],
                    ),
              ),
              const SizedBox(height: 16),

              // Forbidden message
              Text(
                'No tienes permisos para acceder a esta sección.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 8),

              Text(
                'Contacta con tu administrador si crees que esto es un error.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[500],
                    ),
              ),
              const SizedBox(height: 32),

              // Back button
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  child: Text('Volver'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
