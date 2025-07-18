import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/models/rol.dart';
import 'package:tutor_connect/models/usuario.dart'; // Aquí está el enum RolUsuario

import '../../providers/tutoria_provider.dart';
import '../../providers/auth_provider.dart'; // provider real de auth
import '../../app_routes.dart';

class TutoriasDocenteWidget extends StatefulWidget {
  final Usuario user;

  const TutoriasDocenteWidget({super.key, required this.user});

  @override
  State<TutoriasDocenteWidget> createState() => _TutoriasDocenteWidgetState();
}

class _TutoriasDocenteWidgetState extends State<TutoriasDocenteWidget> {
  bool _cargado = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_cargado) {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);
      final tutoriaProvider = Provider.of<TutoriaProvider>(context, listen: false);

      final usuario = authProvider.user;
      if (usuario != null && usuario.rol == RolUsuario.docente) {  // cambio aquí
        tutoriaProvider.cargarTutoriasPorDocente(usuario.id);
      }
      _cargado = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final tutoriaProvider = Provider.of<TutoriaProvider>(context);

    final usuario = authProvider.user;
    final tutorias = tutoriaProvider.tutorias;
    final isLoading = tutoriaProvider.isLoading;

    if (usuario == null) {
      return const Center(child: Text('No se ha iniciado sesión.'));
    }

    if (usuario.rol != RolUsuario.docente) {  // y aquí también
      return const Center(child: Text('No tienes permisos para ver las tutorías.'));
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.crearTutoria);
            },
            icon: const Icon(Icons.add),
            label: const Text('Crear nueva tutoría'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tutorias.isEmpty
                    ? const Center(child: Text('No has creado ninguna tutoría.'))
                    : ListView.builder(
                        itemCount: tutorias.length,
                        itemBuilder: (context, index) {
                          final tutoria = tutorias[index];
                          return Card(
                            child: ListTile(
                              title: Text('Tema: ${tutoria.tema}'),
                              subtitle: Text(
                                '${tutoria.fecha.day}/${tutoria.fecha.month}/${tutoria.fecha.year} – '
                                '${tutoria.horaInicio} - ${tutoria.horaFin}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detalleTutoria,
                                  arguments: tutoria,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
