import 'package:flutter/material.dart';
import 'package:tutor_connect/models/tutoria.dart';
import 'package:tutor_connect/screens/docentes/detalle_tutoria_screen.dart';
import 'package:tutor_connect/screens/perfil_screen.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/DummyScreen.dart';

// 👇 NUEVO: Importa la pantalla para crear tutoría
import 'screens/docentes/crear_tutoria_screen.dart';

class AppRoutes {
  static const login = LoginScreen.routeName;
  static const home = HomeScreen.routeName;
  static const perfil = PerfilScreen.routeName;
  static const solicitudes = '/solicitudes';
  static const solicitarTutoria = '/solicitar_tutoria';
  static const historialTutorias = '/historial_tutorias';
  static const notificaciones = '/notificaciones';
  static const configuracion = '/configuracion';
  static const detalleTutoria = '/detalle-tutoria';

  // 👇 NUEVA ruta
  static const crearTutoria = CrearTutoriaScreen.routeName;

  static Map<String, WidgetBuilder> getRoutes() {
    return {
      login: (context) => const LoginScreen(),
      home: (context) => const HomeScreen(),
      perfil: (context) => const PerfilScreen(),
      solicitudes: (context) => const DummyScreen('Solicitudes'),
      solicitarTutoria: (context) => const DummyScreen('Solicitar tutoría'),
      historialTutorias: (context) => const DummyScreen('Historial de tutorías'),
      notificaciones: (context) => const DummyScreen('Notificaciones'),
      configuracion: (context) => const DummyScreen('Configuración'),

      detalleTutoria: (context) {
        final tutoria = ModalRoute.of(context)!.settings.arguments as Tutoria;
        return DetalleTutoriaScreen(tutoria: tutoria);
      },

      // 👇 NUEVO builder
      crearTutoria: (context) => const CrearTutoriaScreen(),
    };
  }
}
