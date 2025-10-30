import 'package:flutter/material.dart';
// Importamos las 3 pantallas (tabs) que creamos
import 'home_tab.dart';
import 'messages_tab.dart';
import 'settings_tab.dart';

class HomePage extends StatefulWidget {
  // Lo convertimos a StatefulWidget para manejar el estado de la pestaña seleccionada
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Variable para guardar el índice de la pestaña seleccionada
  int _selectedIndex = 0;

  // Lista de los 3 widgets (pestañas) que se mostrarán
  static const List<Widget> _widgetOptions = <Widget>[
    HomeTab(),       // Índice 0: Inicio
    MessagesTab(),   // Índice 1: Mensajes
    SettingsTab(),   // Índice 2: Configuración
  ];

  // Lista de los títulos para la AppBar
  static const List<String> _appBarTitles = <String>[
    "Inicio",
    "Mensajes",
    "Configuración",
  ];

  // Función que se llama cuando el usuario toca una pestaña
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Cambia el título de la AppBar según la pestaña seleccionada
        title: Text(_appBarTitles[_selectedIndex]),
        // Oculta la flecha de "atrás" ya que esta es la pantalla principal
        automaticallyImplyLeading: false, 
      ),
      // Muestra el widget de la pestaña seleccionada
      body: _widgetOptions.elementAt(_selectedIndex),
      
      // Aquí está la Barra de Navegación Inferior
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home), // Icono cuando está activo
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message_outlined),
            activeIcon: Icon(Icons.message),
            label: 'Mensajes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_outlined),
            activeIcon: Icon(Icons.settings),
            label: 'Configuración',
          ),
        ],
        currentIndex: _selectedIndex, // Pestaña activa actualmente
        selectedItemColor: Colors.blue, // Color del ítem seleccionado
        onTap: _onItemTapped, // Llama a nuestra función al tocar
      ),
    );
  }
}