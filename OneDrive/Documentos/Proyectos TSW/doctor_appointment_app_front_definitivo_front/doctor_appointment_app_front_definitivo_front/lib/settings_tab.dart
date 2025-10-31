import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart'; // Importamos tus rutas

class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  String _userName = "Cargando..."; // Para mostrar el nombre del usuario logueado
  // La variable _userEmail fue eliminada porque no se usaba

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Cargar el nombre al iniciar la pantalla
  }

  Future<void> _loadUserData() async {
    User? currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      // Se eliminó la asignación de _userEmail

      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('usuarios')
          .doc(currentUser.uid)
          .get();

      if (mounted && userDoc.exists) {
        // Asegurarse de que el widget todavía esté en pantalla
        setState(() {
          // Hacemos un cast seguro
          final data = userDoc.data() as Map<String, dynamic>?;
          _userName = data?['nombre'] ?? "Usuario";
        });
      } else if (mounted) {
        setState(() {
          _userName = "Usuario"; // Nombre por defecto si no se encuentra
        });
      }
    }
  }

  // Función para cerrar sesión
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return; // Comprobación de seguridad
    // Navega a la pantalla de login y remueve todas las rutas anteriores
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.login, // Usamos la constante de tu archivo de rutas
      (route) => false, // Remueve todas las rutas anteriores
    );
  }

  // Función de ayuda para notificaciones no funcionales
  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      children: [
        // --- 1. TARJETA DE PERFIL SUPERIOR (como en la imagen) ---
        ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            child: Icon(
              Icons.person_outline,
              size: 30,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ),
          title: Text(
            _userName, // Muestra el nombre cargado de Firebase
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: const Text("Profile"), // Texto estático como en la imagen
          onTap: () {
            // Navega a la pantalla de perfil real para editar
            Navigator.pushNamed(context, Routes.profile);
          },
        ),
        const Divider(height: 32, thickness: 1, indent: 16, endIndent: 16),

        // --- 2. OPCIONES DE MENÚ DETALLADAS ---

        // "Profile" - Funcional
        _buildSettingsTile(
          context,
          icon: Icons.person_outline,
          iconColor: Colors.blue,
          title: "Profile",
          onTap: () => Navigator.pushNamed(context, Routes.profile),
        ),
        // "Notifications" - No funcional (como en la imagen)
        _buildSettingsTile(
          context,
          icon: Icons.notifications_none,
          iconColor: Colors.purple,
          title: "Notifications",
          onTap: () => _showSnackbar("La configuración de notificaciones aún no está disponible."),
        ),
        // "Privacy" - Funcional
        _buildSettingsTile(
          context,
          icon: Icons.security,
          iconColor: Colors.indigo,
          title: "Privacy",
          onTap: () => Navigator.pushNamed(context, Routes.privacy),
        ),
        // "General" - No funcional (como en la imagen)
        _buildSettingsTile(
          context,
          icon: Icons.settings_applications_outlined,
          iconColor: Colors.green,
          title: "General",
          onTap: () => _showSnackbar("La configuración general aún no está disponible."),
        ),
        // "About Us" - Funcional
        _buildSettingsTile(
          context,
          icon: Icons.info_outline,
          iconColor: Colors.orange,
          title: "About Us",
          onTap: () => Navigator.pushNamed(context, Routes.about),
        ),

        const Divider(height: 32, thickness: 1, indent: 16, endIndent: 16),

        // --- 3. BOTÓN DE CERRAR SESIÓN ---
        _buildSettingsTile(
          context,
          icon: Icons.logout,
          iconColor: Colors.redAccent,
          title: "Log Out",
          onTap: _signOut, // Llama a la función de cerrar sesión
        ),
      ],
    );
  }

  // --- Widget auxiliar para construir cada item del menú de configuración ---
  Widget _buildSettingsTile(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: Card(
        elevation: 0, 
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: Colors.grey[50], 
        child: ListTile(
          leading: Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1), 
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Icon(icon, color: iconColor),
          ),
          title: Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey),
          onTap: onTap,
        ),
      ),
    );
  }
}