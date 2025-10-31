import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Política de Privacidad")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Última actualización: 30 de octubre de 2025",
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
            SizedBox(height: 16),
            Text(
              "Bienvenido a DoctorAppointmentApp. Su privacidad es de suma importancia para nosotros. Esta Política de Privacidad describe cómo recopilamos, usamos y protegemos la información personal que nos proporciona a través de nuestra aplicación móvil.",
            ),
            SizedBox(height: 24),

            // --- Sección 1 ---
            Text(
              "1. Información que Recopilamos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Recopilamos dos tipos de información:\n"
              "• Información de Cuenta: Información que proporciona al crear su cuenta, como su nombre, correo electrónico y contraseña (la cual se almacena de forma segura y cifrada).\n"
              "• Información de Perfil de Salud: Datos que usted ingresa voluntariamente en su perfil, como su edad, lugar de nacimiento y padecimientos.\n"
              "• Información de Citas: Detalles de las citas que agenda, incluyendo la fecha, la hora y el motivo de la consulta.",
            ),
            SizedBox(height: 24),

            // --- Sección 2 ---
            Text(
              "2. Cómo Usamos su Información",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Utilizamos la información recopilada únicamente para los siguientes propósitos:\n"
              "• Para autenticarlo y permitirle iniciar sesión de forma segura.\n"
              "• Para gestionar y recordarle sus próximas citas.\n"
              "• Para proporcionar al personal médico la información relevante (su perfil y motivo de consulta) necesaria para brindarle una atención adecuada.\n"
              "• Para comunicarnos con usted sobre cambios en el servicio.",
            ),
            SizedBox(height: 24),

            // --- Sección 3 ---
            Text(
              "3. Seguridad y Almacenamiento de Datos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "La seguridad de sus datos es nuestra prioridad. Toda su información se almacena de forma segura utilizando los servicios de Firebase (Google). Implementamos medidas de seguridad estándar de la industria para proteger su información contra el acceso no autorizado.",
            ),
            SizedBox(height: 24),

            // --- Sección 4 ---
            Text(
              "4. Con Quién Compartimos sus Datos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "No vendemos, alquilamos ni compartimos su información personal con terceros, excepto en las siguientes circunstancias:\n"
              "• Con el profesional médico (doctor) con el que usted ha agendado explícitamente una cita.\n"
              "• Si la ley nos obliga a hacerlo para cumplir con un proceso legal.",
            ),
            SizedBox(height: 24),

            // --- Sección 5 ---
            Text(
              "5. Sus Derechos sobre sus Datos",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Usted tiene control sobre su información. En cualquier momento, puede acceder y actualizar la información de su perfil directamente desde la pantalla de \"Perfil\" en la sección de Configuración.",
            ),
            SizedBox(height: 24),

            // --- Sección 6 ---
            Text(
              "6. Contacto",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Si tiene alguna pregunta sobre esta Política de Privacidad, por favor contáctenos en soporte@doctorapp.com.",
            ),
          ],
        ),
      ),
    );
  }
}