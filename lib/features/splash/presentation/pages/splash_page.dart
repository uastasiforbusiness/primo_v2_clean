import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import '../../../../core/presentation/widgets/app_scaffold.dart';

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

      // Simular carga de recursos/DB
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        context.go('/error', extra: 'Error de inicialización');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // No ponemos el icono genérico para que luzca el logo de fondo
            const SizedBox(height: 48),

            // Un indicador de carga más elegante y fino
            const SizedBox(
              width: 40,
              height: 40,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.deepPurple),
              ),
            ),

            const SizedBox(height: 48),

            Text(
              'PRIMO',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w300,
                    letterSpacing: 8,
                    color: Colors.black87,
                  ),
            ),

            const SizedBox(height: 8),

            Text(
              'SOFTWARE SYSTEM',
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 4,
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
