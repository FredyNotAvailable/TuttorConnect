import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../providers/auth_provider.dart';
import '../app_routes.dart';
import '../models/rol.dart';

class HomeScreen extends StatelessWidget {
  static const routeName = '/home';

  const HomeScreen({Key? key}) : super(key: key);

  // Método para cerrar sesión y redirigir al login
  void _logout(BuildContext context) {
    context.read<AuthProvider>().logout();

    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  // Método para ir a la pantalla de perfil
  void _goToPerfil(BuildContext context) {
    Navigator.pushNamed(context, AppRoutes.perfil);
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
        title: Text('Bienvenido ${user.nombre ?? ''}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            tooltip: 'Ver perfil',
            onPressed: () => _goToPerfil(context),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Cerrar sesión',
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Center(
        child: _buildContentForRol(context, user),
      ),
    );
  }

  // Mostrar botones según el rol del usuario
  Widget _buildContentForRol(BuildContext context, Usuario user) {
    switch (user.rol) {
      case RolUsuario.docente:
        return _buildDocenteContent(context, user);
      case RolUsuario.estudiante:
        return _buildEstudianteContent(context, user);
      default:
        return const Text('Tipo de usuario desconocido');
    }
  }

  // Contenido para docente (usando Usuario con rol docente)
  Widget _buildDocenteContent(BuildContext context, Usuario docente) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('👨‍🏫 Panel del Docente', style: TextStyle(fontSize: 22)),
        Text('Nombre: ${docente.nombre ?? ''}'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.tutoriasAsignadas);
          },
          child: const Text('Tutorías asignadas'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.solicitudes);
          },
          child: const Text('Solicitudes de tutoría'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.horarioDocente);
          },
          child: const Text('Mi horario disponible'),
        ),
      ],
    );
  }

  // Contenido para estudiante (usando Usuario con rol estudiante)
  Widget _buildEstudianteContent(BuildContext context, Usuario estudiante) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('👨‍🎓 Panel del Estudiante', style: TextStyle(fontSize: 22)),
        Text('Nombre: ${estudiante.nombre ?? ''}'),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.solicitarTutoria);
          },
          child: const Text('Solicitar tutoría'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.historialTutorias);
          },
          child: const Text('Historial de tutorías'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, AppRoutes.verDocentes);
          },
          child: const Text('Ver docentes disponibles'),
        ),
      ],
    );
  }
}
