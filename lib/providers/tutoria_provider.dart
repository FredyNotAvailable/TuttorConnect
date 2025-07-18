import 'package:flutter/material.dart';
import 'package:tutor_connect/models/tutoria.dart';
import 'package:tutor_connect/services/tutoria_service.dart';

class TutoriaProvider extends ChangeNotifier {
  final TutoriaService _service;

  TutoriaProvider(this._service);

  List<Tutoria> _tutorias = [];
  List<Tutoria> get tutorias => _tutorias;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargarTutoriasPorDocente(String docenteId) async {
    _isLoading = true;
    notifyListeners();

    _tutorias = await _service.obtenerTutoriasPorDocente(docenteId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarTutoriasPorEstudiante(String estudianteId) async {
    _isLoading = true;
    notifyListeners();

    _tutorias = await _service.obtenerTutoriasPorEstudiante(estudianteId);

    _isLoading = false;
    notifyListeners();
  }

  Future<Tutoria> crearTutoria(Tutoria tutoria) async {
    _isLoading = true;
    notifyListeners();

    final tutoriaCreada = await _service.crearTutoriaYRetornar(tutoria);
    _tutorias.add(tutoriaCreada);

    _isLoading = false;
    notifyListeners();

    return tutoriaCreada;
  }

  Future<void> cancelarTutoria(String id) async {
    _isLoading = true;
    notifyListeners();

    await _service.cancelarTutoria(id);
    // Opcional: eliminarla localmente o recargar

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarTutoriasPorIds(List<String> ids) async {
    _isLoading = true;
    notifyListeners();

    _tutorias = await _service.obtenerTutoriasPorIds(ids);

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Nuevo método: agregar estudiante a la tutoría
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId) async {
    await _service.agregarEstudianteATutoria(tutoriaId, estudianteId);

    // Actualizar en la lista local si está cargada
    final index = _tutorias.indexWhere((t) => t.id == tutoriaId);
    if (index != -1) {
      final tutoria = _tutorias[index];
      if (!tutoria.estudiantesIds.contains(estudianteId)) {
        _tutorias[index] = Tutoria(
          id: tutoria.id,
          docenteId: tutoria.docenteId,
          materiaId: tutoria.materiaId,
          aulaId: tutoria.aulaId,
          fecha: tutoria.fecha,
          horaInicio: tutoria.horaInicio,
          horaFin: tutoria.horaFin,
          tema: tutoria.tema,
          estudiantesIds: [...tutoria.estudiantesIds, estudianteId],
          estado: tutoria.estado,
          createdAt: tutoria.createdAt,
        );
        notifyListeners();
      }
    }
  }

  
}
