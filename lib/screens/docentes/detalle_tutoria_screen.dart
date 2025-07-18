import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/tutoria.dart';
import '../../../models/aula.dart';
import '../../../models/materia.dart';
import '../../../models/usuario.dart';
import '../../../models/asistencia_tutoria.dart';

import '../../../providers/aula_provider.dart';
import '../../../providers/materia_provider.dart';
import '../../../providers/usuario_provider.dart';
import '../../../providers/asistencia_tutoria_provider.dart';

class DetalleTutoriaScreen extends StatefulWidget {
  static const routeName = '/detalle-tutoria';

  final Tutoria tutoria;

  const DetalleTutoriaScreen({
    super.key,
    required this.tutoria,
  });

  @override
  State<DetalleTutoriaScreen> createState() => _DetalleTutoriaScreenState();
}

class _DetalleTutoriaScreenState extends State<DetalleTutoriaScreen> {
  Aula? _aula;
  Materia? _materia;
  List<Usuario> _estudiantes = [];
  List<AsistenciaTutoria> _asistencias = [];
  bool _isLoading = true;

  Usuario? _usuarioActual;

  bool get _esDocente {
    if (_usuarioActual == null) return false;
    return _usuarioActual!.id == widget.tutoria.docenteId;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
      setState(() {
        _usuarioActual = usuarioProvider.usuario;
      });
      _cargarDatos();
    });
  }

  Future<void> _cargarDatos() async {
    setState(() => _isLoading = true);

    final aulaProvider = Provider.of<AulaProvider>(context, listen: false);
    final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);
    final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
    final asistenciaProvider = Provider.of<AsistenciaTutoriaProvider>(context, listen: false);

    final aula = await aulaProvider.obtenerAulaPorId(widget.tutoria.aulaId);
    final materia = await materiaProvider.obtenerMateriaPorId(widget.tutoria.materiaId);
    final estudiantes = await usuarioProvider.cargarUsuariosPorIds(widget.tutoria.estudiantesIds);
    await asistenciaProvider.cargarAsistenciasPorTutoria(widget.tutoria.id);
    final asistencias = asistenciaProvider.asistencias;

    setState(() {
      _aula = aula;
      _materia = materia;
      _estudiantes = estudiantes;
      _asistencias = asistencias;
      _isLoading = false;
    });
  }

  bool _estaPresente(String estudianteId) {
    final asistencia = _asistencias.firstWhere(
      (a) => a.estudianteId == estudianteId,
      orElse: () => AsistenciaTutoria(
        id: '',
        tutoriaId: widget.tutoria.id,
        estudianteId: estudianteId,
        fechaRegistro: widget.tutoria.fecha,
        estado: 'ausente',
      ),
    );
    return asistencia.estado == 'presente';
  }

  Future<void> _toggleAsistencia(bool? valor, Usuario estudiante) async {
    if (!_esDocente) return; // Solo docente puede modificar

    final asistenciaProvider = Provider.of<AsistenciaTutoriaProvider>(context, listen: false);

    final existente = _asistencias.firstWhere(
      (a) => a.estudianteId == estudiante.id,
      orElse: () => AsistenciaTutoria(
        id: '', // nuevo registro
        tutoriaId: widget.tutoria.id,
        estudianteId: estudiante.id,
        fechaRegistro: widget.tutoria.fecha,
        estado: 'ausente',
      ),
    );

    final nuevoEstado = (valor ?? false) ? 'presente' : 'ausente';
    final nuevaAsistencia = AsistenciaTutoria(
      id: existente.id.isEmpty ? '${widget.tutoria.id}_${estudiante.id}' : existente.id,
      tutoriaId: widget.tutoria.id,
      estudianteId: estudiante.id,
      fechaRegistro: widget.tutoria.fecha,
      estado: nuevoEstado,
    );

    if (existente.id.isEmpty) {
      await asistenciaProvider.registrarAsistencia(nuevaAsistencia);
      _asistencias.add(nuevaAsistencia);
    } else {
      await asistenciaProvider.actualizarAsistencia(nuevaAsistencia);
      final index = _asistencias.indexWhere((a) => a.id == existente.id);
      if (index >= 0) _asistencias[index] = nuevaAsistencia;
    }

    setState(() {}); // refresca UI
  }

  @override
  Widget build(BuildContext context) {
    // Mientras no se cargue el usuario actual, muestra un loader
    if (_usuarioActual == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle de la tutoría')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  Text('Tema', style: Theme.of(context).textTheme.titleMedium),
                  Text(widget.tutoria.tema, style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 16),

                  _infoRow('Materia', _materia?.nombre ?? 'No disponible'),
                  _infoRow('Aula', _aula?.nombre ?? 'No disponible'),
                  _infoRow('Fecha', widget.tutoria.fecha.toLocal().toString().split(' ')[0]),
                  _infoRow('Hora', '${widget.tutoria.horaInicio} - ${widget.tutoria.horaFin}'),
                  _infoRow('Estado', widget.tutoria.estado),

                  const Divider(height: 32),

                  Text('Estudiantes', style: Theme.of(context).textTheme.titleMedium),

                  if (_estudiantes.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(child: Text('No hay estudiantes inscritos')),
                    )
                  else
                    ..._estudiantes.map(
                      (e) => CheckboxListTile(
                        value: _estaPresente(e.id),
                        title: Text(e.nombre ?? 'Sin nombre'),
                        subtitle: Text(e.correo),
                        onChanged: _esDocente ? (val) => _toggleAsistencia(val, e) : null,
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value.isNotEmpty ? value : 'No disponible')),
        ],
      ),
    );
  }
}
