import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/providers/matricula_provider.dart';
import 'package:tutor_connect/providers/usuario_provider.dart';

import '../models/usuario.dart';
import '../providers/auth_provider.dart';
import '../app_routes.dart';
import '../models/rol.dart';

import '../widgets/docentes/home_docente_widget.dart';
import '../widgets/estudiantes/home_estudiante_widget.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/home';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_cargado) {
      final user = context.read<AuthProvider>().user;
      if (user != null) {
        context.read<UsuarioProvider>().cargarUsuario(user.id);
        context.read<MatriculaProvider>().cargarMatricula(user.id);
        // context.read<CarreraProvider>().cargarCarrera();
      }
      _cargado = true;
    }
  }

  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  void _goToPerfil(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.perfil);
  }

  void _goToNotificaciones(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.notificaciones);
  }

  @override
  Widget build(BuildContext context) {

    final Usuario? user = context.watch<AuthProvider>().user;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('Usuario no autenticado')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Hola, ${user.nombre ?? ''} 👋'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Notificaciones',
            onPressed: () => _goToNotificaciones(context),
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Perfil',
            onPressed: () => _goToPerfil(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          switch (user.rol) {
            case RolUsuario.docente:
              return HomeDocenteWidget(user: user);
            case RolUsuario.estudiante:
              return HomeEstudianteWidget(user: user);
          }
        },
      ),
    );
  }
}
