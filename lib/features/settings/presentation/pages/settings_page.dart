import 'package:flutter/material.dart';

/// SettingsPage - Administration settings screen
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),

          // General Settings
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Generales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.store),
                  title: const Text('Información del Negocio'),
                  subtitle: const Text('Nombre, dirección, contacto'),
                  onTap: () {
                    // TODO: Navigate to business info
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.receipt),
                  title: const Text('Configuración de Ticket'),
                  subtitle: const Text('Formato, impresora, plantillas'),
                  onTap: () {
                    // TODO: Navigate to receipt settings
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.color_lens),
                  title: const Text('Tema de la Aplicación'),
                  subtitle: const Text('Oscuro/Claro/Sistema'),
                  onTap: () {
                    // TODO: Navigate to theme settings
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Security Settings
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Seguridad',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Cambiar PIN'),
                  subtitle: const Text('Actualizar PIN de acceso'),
                  onTap: () {
                    // TODO: Navigate to change PIN
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.security),
                  title: const Text('Configuración de Sesión'),
                  subtitle: const Text('Timeout, bloqueo automático'),
                  onTap: () {
                    // TODO: Navigate to session settings
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Advanced Settings
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Avanzado',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.storage),
                  title: const Text('Base de Datos'),
                  subtitle: const Text('Backup, restaurar, optimizar'),
                  onTap: () {
                    // TODO: Navigate to database settings
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.bug_report),
                  title: const Text('Registros de Error'),
                  subtitle: const Text('Ver y exportar logs'),
                  onTap: () {
                    // TODO: Navigate to error logs
                  },
                ),
                const Divider(height: 0),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('Acerca de'),
                  subtitle: const Text('Versión, licencia, créditos'),
                  onTap: () {
                    // TODO: Show about dialog
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Version
          Center(
            child: Text(
              'PRIMO V2 • Versión 1.0.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey[500],
                  ),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
