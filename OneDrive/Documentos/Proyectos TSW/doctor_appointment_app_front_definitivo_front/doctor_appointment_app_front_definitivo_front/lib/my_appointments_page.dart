import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Asegúrate de tener intl en tu pubspec.yaml
import 'routes.dart';

class MyAppointmentsPage extends StatefulWidget {
  const MyAppointmentsPage({super.key});

  @override
  State<MyAppointmentsPage> createState() => _MyAppointmentsPageState();
}

class _MyAppointmentsPageState extends State<MyAppointmentsPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // --- Función para BORRAR (Delete) ---
  Future<void> _deleteAppointment(String docId) async {
    // 1. Mostrar diálogo de confirmación
    final bool? confirmDelete = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Borrado'),
          content: const Text('¿Estás seguro de que deseas cancelar esta cita?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Sí
              child: const Text('Sí, cancelar'),
            ),
          ],
        );
      },
    );

    // 2. Si el usuario confirma, borrar el documento
    if (confirmDelete == true) {
      try {
        await _firestore.collection('citas').doc(docId).delete();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Cita cancelada exitosamente")),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error al cancelar la cita: $e")),
          );
        }
      }
    }
  }

  // --- Función para Navegar a ACTUALIZAR (Update) ---
  void _navigateToEdit(String docId) {
    // Navegamos a la pantalla de agendar, pero pasándole el ID
    // para que sepa que debe "Editar" en lugar de "Crear"
    Navigator.pushNamed(context, Routes.appointment, arguments: docId);
  }

  @override
  Widget build(BuildContext context) {
    final User? user = _auth.currentUser;
    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Mis Citas")),
        body: const Center(child: Text("Inicia sesión para ver tus citas.")),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Mis Citas")),
      body: StreamBuilder<QuerySnapshot>(
        // --- Stream para VISUALIZAR (Read) ---
        // Esta línea busca en 'citas' solo los documentos donde
        // el 'id_paciente' es IGUAL al ID del usuario que inició sesión.
        stream: _firestore
            .collection('citas')
            .where('id_paciente', isEqualTo: user.uid) 
            .orderBy('fecha_hora_cita', descending: false) 
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          // Si no hay datos, es porque el usuario actual NO tiene citas
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No tienes citas programadas."));
          }
          if (snapshot.hasError) {
            return const Center(child: Text("Error al cargar las citas."));
          }

          // Si SÍ hay datos, los muestra en una lista
          final appointments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: appointments.length,
            itemBuilder: (context, index) {
              final doc = appointments[index];
              final data = doc.data() as Map<String, dynamic>;
              
              final Timestamp timestamp = data['fecha_hora_cita'];
              final DateTime date = timestamp.toDate();
              final String formattedDate = DateFormat('EEE, d MMM yyyy, h:mm a', 'es').format(date); 

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: ListTile(
                  title: Text(data['motivo_consulta'] ?? 'Sin motivo'),
                  subtitle: Text(formattedDate),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Botón de Editar
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => _navigateToEdit(doc.id),
                      ),
                      // Botón de Borrar
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _deleteAppointment(doc.id),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}