import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class SettingsTab extends StatelessWidget {
  const SettingsTab({super.key});

  // Función de LogOut
  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      // Limpiamos todo el historial de navegación y volvemos al Login
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routes.login,
        (route) => false, // Esta condición elimina todas las rutas anteriores
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error al cerrar sesión: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        // 1. Perfil
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text("Perfil"),
          subtitle: const Text("Edita tu información personal"),
          onTap: () {
            // Navega a la pantalla de perfil que ya tenías
            Navigator.pushNamed(context, Routes.profile);
          },
        ),
        // 2. Privacidad
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text("Privacidad"),
          onTap: () {
            // Navega a la nueva pantalla de privacidad
            Navigator.pushNamed(context, Routes.privacy);
          },
        ),
        // 3. Sobre Nosotros
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text("Sobre nosotros"),
          onTap: () {
            // Navega a la nueva pantalla de "Sobre nosotros"
            Navigator.pushNamed(context, Routes.about);
          },
        ),
        const Divider(),
        // 4. LogOut
        ListTile(
          leading: const Icon(Icons.logout, color: Colors.red),
          title: const Text("Cerrar Sesión", style: TextStyle(color: Colors.red)),
          onTap: () {
            // Llama a la función de cerrar sesión
            _signOut(context);
          },
        ),
      ],
    );
  }
}