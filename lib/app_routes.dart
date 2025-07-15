import 'package:flutter/material.dart';
import 'package:tutor_connect/screens/perfil_screen.dart';

// Importa tus pantallas aquí
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';          // Nuevo: Home general
import 'screens/DummyScreen.dart';          // Nuevo: Home general

class AppRoutes {
  static const login = LoginScreen.routeName;
  static const home = HomeScreen.routeName;            // Nueva ruta para Home general
  static const perfil = PerfilScreen.routeName;            // Nueva ruta para Home general
  static const tutoriasAsignadas = '/tutorias_asignadas';
  static const solicitudes = '/solicitudes';
  static const horarioDocente = '/horario_docente';
  static const solicitarTutoria = '/solicitar_tutoria';
  static const historialTutorias = '/historial_tutorias';
  static const verDocentes = '/ver_docentes';
  static const notificaciones = '/notificaciones';
  static const configuracion = '/configuracion';


  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),           // Ruta Home general
      perfil: (context) => const PerfilScreen(),
      tutoriasAsignadas: (context) => const DummyScreen('Tutorías asignadas'),
      solicitudes: (context) => const DummyScreen('Solicitudes'),
      horarioDocente: (context) => const DummyScreen('Horario disponible'),
      solicitarTutoria: (context) => const DummyScreen('Solicitar tutoría'),
      historialTutorias: (context) => const DummyScreen('Historial de tutorías'),
      verDocentes: (context) => const DummyScreen('Docentes disponibles'),
      notificaciones: (context) => const DummyScreen('Notificaiones'),
      configuracion: (context) => const DummyScreen('Configuracion'),
    };
  }
}
