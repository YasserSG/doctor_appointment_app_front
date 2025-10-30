import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'routes.dart'; 

class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _userName = "Usuario"; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final user = _auth.currentUser;
    if (user == null) return;
    try {
      final doc = await _firestore.collection('usuarios').doc(user.uid).get();
      if (mounted && doc.exists) {
        final data = doc.data()!;
        setState(() {
          _userName = data['nombre'] ?? user.email ?? "Usuario";
          if (_userName.trim().isEmpty) {
             _userName = user.email ?? "Usuario";
          }
        });
      } else if (mounted) {
         setState(() {
           _userName = user.email ?? "Usuario";
         });
      }
    } catch (e) {
       if (mounted) {
         setState(() {
           _userName = user.email ?? "Usuario";
         });
       }
    }
  }

  final List<String> especialistas = [
    "Cardiología", "Dermatología", "Pediatría", "Ginecología", "Medicina General",
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "¡Hola, $_userName!",
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "¿En qué podemos ayudarte?",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.calendar_month,
                    label: "Agendar Cita",
                    color: Colors.blue.shade100,
                    onTap: () {
                      Navigator.pushNamed(context, Routes.appointment);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildActionCard(
                    context,
                    icon: Icons.lightbulb_outline,
                    label: "Consejos Médicos",
                    color: Colors.orange.shade100,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Función no implementada")),
                      );
                    },
                  ),
                ),
              ],
            ),

            // --- ESTE ES EL NUEVO WIDGET ---
            const SizedBox(height: 16),
            _buildActionCard(
              context,
              icon: Icons.list_alt, // Icono de lista
              label: "Mis Citas",
              color: Colors.green.shade100,
              onTap: () {
                // NAVEGA A LA PÁGINA DE VISUALIZACIÓN
                Navigator.pushNamed(context, Routes.myAppointments);
              },
            ),
            // --- FIN DEL NUEVO WIDGET ---

            const SizedBox(height: 32),
            const Text(
              "Especialistas",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true, 
              physics: const NeverScrollableScrollPhysics(),
              itemCount: especialistas.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.medical_services_outlined),
                    title: Text(especialistas[index]),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: () {},
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
             const Text(
              "Doctores Populares",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Card(
              child: ListTile(
                leading: CircleAvatar(child: Text("DR")),
                title: Text("Dr. Alan"),
                subtitle: Text("Cardiólogo"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget de ayuda para crear las tarjetas de acción
  Widget _buildActionCard(BuildContext context,
      {required IconData icon,
      required String label,
      required Color color,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: color,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40, color: Colors.black87),
              const SizedBox(height: 10),
              Text(label, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}