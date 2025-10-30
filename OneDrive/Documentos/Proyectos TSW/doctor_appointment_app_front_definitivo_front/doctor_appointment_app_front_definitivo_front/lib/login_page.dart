import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'routes.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _loading = false;

  // --- Lógica de Iniciar Sesión ---
  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() => _loading = true);

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Bienvenido ${userCredential.user!.email}")),
      );
      Navigator.pushReplacementNamed(context, Routes.home);

    } on FirebaseAuthException catch (e) {
      String message = "Error al iniciar sesión.";
      if (e.code == 'user-not-found') {
        message = "Usuario no encontrado.";
      } else if (e.code == 'wrong-password') {
        message = "Contraseña incorrecta.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  // --- Lógica para "Olvidó Contraseña" ---
  Future<void> _resetPassword() async {
    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor, ingresa tu correo para recuperar la contraseña.")),
      );
      return;
    }
    
    setState(() => _loading = true);
    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Se ha enviado un correo de recuperación. Revisa tu bandeja de entrada.")),
      );
    } on FirebaseAuthException catch (e) {
      String message = (e.code == 'user-not-found') ? "Usuario no encontrado." : "Ocurrió un error.";
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("DoctorAppointmentApp")),
      body: _loading 
          ? const Center(child: CircularProgressIndicator()) 
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Usamos SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // --- 1. IMAGEN AÑADIDA ---
                Image.asset(
                  'assets/images/login_hero.png',
                  height: 200, // Ajusta la altura como gustes
                ),
                const SizedBox(height: 20),
                const Text(
                  "Bienvenido de Nuevo",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),
                
                // --- 2. CAMPO DE CORREO ---
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Correo Electrónico",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa tu correo";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                // --- 3. CAMPO DE CONTRASEÑA ---
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: "Contraseña",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Por favor ingresa tu contraseña";
                    }
                    return null;
                  },
                ),
                
                // --- 4. BOTÓN "Olvidó su contraseña" ---
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _resetPassword,
                    child: const Text("¿Olvidó su contraseña?"),
                  ),
                ),
                const SizedBox(height: 16),
                
                // --- 5. BOTÓN "Iniciar Sesión" ---
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _signIn,
                    child: const Text("Iniciar Sesión"),
                  ),
                ),
                const SizedBox(height: 24),
                
                // --- 6. BOTÓN "Crear una cuenta" ---
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, Routes.register);
                  },
                  child: const Text("Crear una cuenta nueva"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}