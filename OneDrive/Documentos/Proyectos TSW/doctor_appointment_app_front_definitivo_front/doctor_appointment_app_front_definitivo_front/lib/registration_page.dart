import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden")),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      // Éxito, muestra mensaje y regresa al Login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("¡Cuenta creada! Por favor, inicia sesión.")),
      );
      Navigator.pop(context); // Regresa a la pantalla de Login

    } on FirebaseAuthException catch (e) {
      String message = "Ocurrió un error.";
      if (e.code == 'weak-password') {
        message = 'La contraseña es muy débil.';
      } else if (e.code == 'email-already-in-use') {
        message = 'El correo ya está en uso por otra cuenta.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crear Cuenta Nueva")),
      body: _loading 
          ? const Center(child: CircularProgressIndicator()) 
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Para evitar overflow
            child: Column(
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => (value == null || value.isEmpty) ? "Ingresa un correo" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => (value == null || value.isEmpty) ? "Ingresa una contraseña" : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(
                    labelText: "Confirmar Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) => (value == null || value.isEmpty) ? "Confirma tu contraseña" : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _signUp,
                  child: const Text("Registrarse"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}