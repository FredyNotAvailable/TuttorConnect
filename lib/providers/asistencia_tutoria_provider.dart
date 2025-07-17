import 'package:flutter/material.dart';
import 'package:tutor_connect/models/asistencia_tutoria.dart';
import 'package:tutor_connect/services/asistencia_tutoria_service.dart';

class AsistenciaTutoriaProvider extends ChangeNotifier {
  final AsistenciaTutoriaService _service;

  AsistenciaTutoriaProvider(this._service);

  List<AsistenciaTutoria> _asistencias = [];
  List<AsistenciaTutoria> get asistencias => _asistencias;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargarAsistenciasPorTutoria(String tutoriaId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _asistencias = await _service.obtenerAsistenciasPorTutoria(tutoriaId);
    } catch (e) {
      // Aquí podrías manejar el error con logs o mensajes a la UI
      _asistencias = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> registrarAsistencia(AsistenciaTutoria asistencia) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.registrarAsistencia(asistencia);
      await cargarAsistenciasPorTutoria(asistencia.tutoriaId); // Refrescar
    } catch (e) {
      // Manejo de error
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarAsistencia(AsistenciaTutoria asistencia) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _service.actualizarAsistencia(asistencia);
      await cargarAsistenciasPorTutoria(asistencia.tutoriaId); // Refrescar
    } catch (e) {
      // Manejo de error
    }

    _isLoading = false;
    notifyListeners();
  }
}
