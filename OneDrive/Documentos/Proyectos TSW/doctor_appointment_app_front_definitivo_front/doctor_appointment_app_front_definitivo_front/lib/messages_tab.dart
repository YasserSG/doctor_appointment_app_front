import 'package:flutter/material.dart';

class MessagesTab extends StatelessWidget {
  MessagesTab({super.key});

  // --- 1. DATOS FALSOS PARA LA UI ---
  // Lista para los doctores "activos" (horizontal)
  final List<String> activeDoctors = [
    'Dr. Salas', 'Dr. Ruiz', 'Dr. Kim', 'Dr. Chen', 'Dr. Lara'
  ];

  // Lista para los 3 chats "realistas" (vertical)
  final List<Map<String, String>> recentChats = [
    {
      "name": "Dr. Alan",
      "message": "Perfecto, nos vemos en la cita del viernes.",
      "time": "11:30 AM"
    },
    {
      "name": "Dr. Ruiz",
      "message": "Aquí están los resultados de sus análisis.",
      "time": "Ayer"
    },
    {
      "name": "Soporte App",
      "message": "Bienvenido a DoctorAppointmentApp.",
      "time": "Lunes"
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Usamos un ListView principal para que toda la pantalla sea scrollable
    return ListView(
      children: [
        
        // --- 2. BARRA DE BÚSQUEDA ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
          child: TextField(
            readOnly: true, // No es funcional
            onTap: () {}, // No hace nada al tocar
            decoration: InputDecoration(
              hintText: "Buscar doctor o mensaje...",
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
        
        // --- 3. SECCIÓN DE DOCTORES ACTIVOS (HORIZONTAL) ---
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            "Doctores Activos",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(
          height: 100, // Altura fija para la lista horizontal
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: activeDoctors.length,
            padding: const EdgeInsets.only(left: 16),
            itemBuilder: (context, index) {
              return SizedBox(
                width: 80, // Ancho fijo para cada item
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        activeDoctors[index].substring(4, 6), // "Sa", "Ru", etc.
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      activeDoctors[index],
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12),
                    )
                  ],
                ),
              );
            },
          ),
        ),

        // --- 4. SECCIÓN DE HISTORIAL DE CHATS (VERTICAL) ---
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 8.0),
          child: Text(
            "Historial de Chats",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        
        // Usamos un ListView.builder con los 3 chats
        ListView.builder(
          itemCount: 3, 
          shrinkWrap: true, // Para que funcione dentro del otro ListView
          physics: const NeverScrollableScrollPhysics(), // Desactiva su scroll
          itemBuilder: (context, index) {
            final chat = recentChats[index];
            return Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                    child: Icon(
                      // Icono diferente para "Soporte"
                      chat['name'] == "Soporte App" ? Icons.support_agent : Icons.person_outline,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  title: Text(
                    chat['name']!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    chat['message']!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    chat['time']!,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  onTap: () {}, // No hace nada, pero mantiene el efecto
                ),
                const Divider(height: 1, indent: 80, endIndent: 16),
              ],
            );
          },
        ),
      ],
    );
  }
}