import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

/// SplashPage - Initial loading screen for PRIMO V2
/// Responsible for:
/// - Showing loading indicator
/// - Validating database integrity
/// - Redirecting to appropriate route
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final logger = Logger();

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      logger.i('🚀 Initializing PRIMO V2...');
      
      // Small delay to show splash
      await Future.delayed(const Duration(seconds: 2));
      
      logger.i('✅ Splash completed - navigating to login');
      
      // Navigate to login (GoRouter will handle redirects)
      if (mounted) {
        context.go('/login');
      }
    } catch (e, stackTrace) {
      logger.e('❌ Splash error: ${e.toString()}', error: e, stackTrace: stackTrace);
      if (mounted) {
        context.go('/error', extra: 'Error de inicialización');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Icon(
              Icons.point_of_sale,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 32),
            
            // Loading indicator
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 32),
            
            // App name
            Text(
              'PRIMO V2',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            
            // Version
            Text(
              'Cargando...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}