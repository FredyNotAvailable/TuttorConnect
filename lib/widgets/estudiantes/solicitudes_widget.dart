import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/usuario.dart';
import '../../models/solicitud_tutoria.dart';
import '../../models/tutoria.dart';
import '../../models/materia.dart';

import '../../providers/solicitud_tutoria_provider.dart';
import '../../providers/tutoria_provider.dart';
import '../../providers/usuario_provider.dart';
import '../../providers/materia_provider.dart';

class SolicitudesWidget extends StatefulWidget {
  final Usuario user;

  const SolicitudesWidget({super.key, required this.user});

  @override
  State<SolicitudesWidget> createState() => _SolicitudesWidgetState();
}

class _SolicitudesWidgetState extends State<SolicitudesWidget> {
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      final solicitudProv = Provider.of<SolicitudTutoriaProvider>(context, listen: false);
      final tutoriaProv = Provider.of<TutoriaProvider>(context, listen: false);
      final usuarioProv = Provider.of<UsuarioProvider>(context, listen: false);
      final materiaProv = Provider.of<MateriaProvider>(context, listen: false);

      await solicitudProv.cargarSolicitudesPorEstudiante(widget.user.id);

      final tutoriasIds = solicitudProv.solicitudes.map((s) => s.tutoriaId).toSet().toList();
      await tutoriaProv.cargarTutoriasPorIds(tutoriasIds);

      final docentesIds = tutoriaProv.tutorias.map((t) => t.docenteId).toSet().toList();
      final materiasIds = tutoriaProv.tutorias.map((t) => t.materiaId).toSet().toList();

      await usuarioProv.cargarUsuariosPorIds(docentesIds);
      await materiaProv.cargarMateriasPorIds(materiasIds);

      setState(() {
        _cargando = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Notificaciones para ${widget.user.nombre ?? 'usuario'}'),
      ),
      body: Consumer4<SolicitudTutoriaProvider, TutoriaProvider, UsuarioProvider, MateriaProvider>(
        builder: (context, solicitudProv, tutoriaProv, usuarioProv, materiaProv, _) {
          final solicitudes = solicitudProv.solicitudes;
          final tutorias = tutoriaProv.tutorias;
          final docentesMap = {for (var u in usuarioProv.usuariosCache) u.id: u};
          final materiasMap = {for (var m in materiaProv.materias) m.id: m};

          if (solicitudes.isEmpty) {
            return const Center(child: Text('No tienes solicitudes de tutoría.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: solicitudes.length,
            itemBuilder: (context, index) {
              final solicitud = solicitudes[index];
              final tutoria = tutorias.firstWhere(
                (t) => t.id == solicitud.tutoriaId,
                orElse: () => Tutoria(
                  id: '',
                  docenteId: '',
                  materiaId: '',
                  aulaId: '',
                  fecha: DateTime.now(),
                  horaInicio: '',
                  horaFin: '',
                  tema: '',
                  estudiantesIds: [],
                  estado: '',
                  createdAt: DateTime.now(),
                ),
              );

              final docente = docentesMap[tutoria.docenteId];
              final materia = materiasMap[tutoria.materiaId];

              final nombreDocente = docente?.nombre ?? 'Desconocido';
              final rolDocente = docente?.rol.name ?? 'Docente';
              final nombreMateria = materia?.nombre ?? 'Materia desconocida';

              final fechaRecibida = solicitud.fechaRespuesta ?? solicitud.createdAt;

              final bool estaPendiente = solicitud.estado == 'pendiente';

              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 16),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Invitación a la tutoría',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'El $rolDocente $nombreDocente te ha invitado a la tutoría "$nombreMateria".',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 8),
                      if (fechaRecibida != null)
                        Text(
                          'Recibida: ${fechaRecibida.day}/${fechaRecibida.month}/${fechaRecibida.year} '
                          '${fechaRecibida.hour.toString().padLeft(2, '0')}:${fechaRecibida.minute.toString().padLeft(2, '0')}',
                          style: const TextStyle(color: Colors.grey),
                        )
                      else
                        const SizedBox.shrink(),

                      const SizedBox(height: 12),
                      if (estaPendiente)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                try {
                                  final nueva = solicitud.copyWith(
                                    estado: 'rechazado',
                                    fechaRespuesta: DateTime.now(),
                                  );
                                  await solicitudProv.actualizarSolicitud(nueva);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Solicitud rechazada')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al rechazar solicitud: $e')),
                                  );
                                }
                              },
                              child: const Text(
                                'Rechazar',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () async {
                                try {
                                  final nueva = solicitud.copyWith(
                                    estado: 'aceptado',
                                    fechaRespuesta: DateTime.now(),
                                  );

                                  // 1. Actualiza solicitud
                                  await solicitudProv.actualizarSolicitud(nueva);

                                  // 2. Agrega estudiante a tutoría
                                  await tutoriaProv.agregarEstudianteATutoria(
                                    solicitud.tutoriaId,
                                    solicitud.estudianteId,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Solicitud aceptada')),
                                  );
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error al aceptar solicitud: $e')),
                                  );
                                }
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        )
                      else
                        Text(
                          'Estado: ${solicitud.estado[0].toUpperCase()}${solicitud.estado.substring(1)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                            fontSize: 16,
                          ),
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
