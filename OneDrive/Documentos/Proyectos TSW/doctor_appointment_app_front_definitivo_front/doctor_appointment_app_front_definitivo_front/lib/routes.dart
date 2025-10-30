import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_page.dart';
import 'profile_page.dart';
import 'privacy_page.dart';
import 'about_page.dart';
import 'appointment_page.dart';
import 'my_appointments_page.dart';
import 'registration_page.dart'; // <-- 1. IMPORTAR LA NUEVA PÁGINA

class Routes {
  static const String login = '/login';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String privacy = '/privacy';
  static const String about = '/about';
  static const String appointment = '/appointment';
  static const String myAppointments = '/my_appointments';
  static const String register = '/register'; // <-- 2. AÑADIR NUEVA RUTA

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => LoginPage());
      case home:
        return MaterialPageRoute(builder: (_) => const HomePage());
      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyPage());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutPage());
      
      case appointment:
        final String? appointmentId = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => AppointmentPage(appointmentId: appointmentId),
        );

      case myAppointments: 
        return MaterialPageRoute(builder: (_) => const MyAppointmentsPage());

      case register: // <-- 3. AÑADIR ESTE CASE
        return MaterialPageRoute(builder: (_) => const RegistrationPage());

      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          ),
        );
    }
  }
}