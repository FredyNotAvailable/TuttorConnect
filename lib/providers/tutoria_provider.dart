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

  Future<void> crearTutoria(Tutoria tutoria) async {
    _isLoading = true;
    notifyListeners();

    await _service.crearTutoria(tutoria);
    // Puedes recargar la lista o actualizar el estado aquí si quieres

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cancelarTutoria(String id) async {
    _isLoading = true;
    notifyListeners();

    await _service.cancelarTutoria(id);
    // Actualizar lista o estado si es necesario

    _isLoading = false;
    notifyListeners();
  }
}
