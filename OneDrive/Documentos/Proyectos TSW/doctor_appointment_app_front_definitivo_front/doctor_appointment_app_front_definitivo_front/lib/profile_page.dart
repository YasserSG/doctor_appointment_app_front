import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool _loading = false;

  // --- 1. CONTROLADORES ACTUALIZADOS ---
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController(); // NUEVO
  final TextEditingController lugarNacimientoController = TextEditingController(); // NUEVO
  final TextEditingController padecimientosController = TextEditingController(); // RENOMBRADO

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // --- 2. FUNCIÓN DE CARGA ACTUALIZADA ---
  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    setState(() => _loading = true);

    try {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (mounted && doc.exists) {
        final data = doc.data()!;
        // Llenamos los controladores con los datos de Firebase
        nombreController.text = data['nombre'] ?? '';
        edadController.text = data['edad'] ?? ''; // NUEVO
        lugarNacimientoController.text = data['lugar_nacimiento'] ?? ''; // NUEVO
        padecimientosController.text = data['padecimientos'] ?? ''; // RENOMBRADO
      }
    } catch (e) {
      // Manejo de error
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // --- 3. FUNCIÓN DE GUARDADO ACTUALIZADA ---
  Future<void> _saveUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;

    setState(() => _loading = true);

    try {
      // Usamos .set con merge:true para crear o actualizar el documento
      await _firestore.collection('usuarios').doc(user.uid).set({
        'nombre': nombreController.text.trim(),
        'edad': edadController.text.trim(), // NUEVO
        'lugar_nacimiento': lugarNacimientoController.text.trim(), // NUEVO
        'padecimientos': padecimientosController.text.trim(), // RENOMBRADO
        'email': user.email, // Guardamos el email por referencia
        'uid': user.uid,
      }, SetOptions(merge: true)); // merge:true evita sobreescribir otros campos

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Información guardada exitosamente")),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al guardar: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Editar Perfil")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Correo: ${user?.email ?? 'No disponible'}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 24),

                    // --- 4. FORMULARIO ACTUALIZADO ---
                    TextField(
                      controller: nombreController,
                      decoration: const InputDecoration(labelText: "Nombre completo"),
                    ),
                    const SizedBox(height: 12),

                    TextField( // NUEVO
                      controller: edadController,
                      decoration: const InputDecoration(labelText: "Edad"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),

                    TextField( // NUEVO
                      controller: lugarNacimientoController,
                      decoration: const InputDecoration(labelText: "Lugar de nacimiento"),
                    ),
                    const SizedBox(height: 12),

                    TextField( // RENOMBRADO
                      controller: padecimientosController,
                      decoration: const InputDecoration(labelText: "Padecimientos"),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: _saveUserData,
                      child: const Text("Guardar información"),
                    ),
                    const SizedBox(height: 20),
                    
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Regresa a la pantalla de Configuración
                      },
                      child: const Text("Volver"),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}