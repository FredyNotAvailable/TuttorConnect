import 'package:flutter/material.dart';
import 'package:tutor_connect/models/solicitud_tutoria.dart';
import 'package:tutor_connect/services/solicitud_tutoria_service.dart';

class SolicitudTutoriaProvider extends ChangeNotifier {
  final SolicitudTutoriaService _service;

  SolicitudTutoriaProvider(this._service);

  List<SolicitudTutoria> _solicitudes = [];
  List<SolicitudTutoria> get solicitudes => _solicitudes;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargarSolicitudesPorTutoria(String tutoriaId) async {
    _isLoading = true;
    notifyListeners();

    _solicitudes = await _service.obtenerSolicitudesPorTutoria(tutoriaId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> cargarSolicitudesPorEstudiante(String estudianteId) async {
    _isLoading = true;
    notifyListeners();

    _solicitudes = await _service.obtenerSolicitudesPorEstudiante(estudianteId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearSolicitud(SolicitudTutoria solicitud) async {
    _isLoading = true;
    notifyListeners();

    await _service.crearSolicitud(solicitud);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> crearSolicitudes(List<SolicitudTutoria> solicitudes) async {
    _isLoading = true;
    notifyListeners();

    await _service.crearSolicitudes(solicitudes);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> actualizarSolicitud(SolicitudTutoria solicitud) async {
    _isLoading = true;
    notifyListeners();

    await _service.actualizarSolicitud(solicitud);

    _isLoading = false;
    notifyListeners();
  }
  
  Future<void> actualizarEstadoSolicitud(String solicitudId, String nuevoEstado) async {
    _isLoading = true;
    notifyListeners();

    final solicitud = _solicitudes.firstWhere((s) => s.id == solicitudId);
    final actualizada = SolicitudTutoria(
      id: solicitud.id,
      tutoriaId: solicitud.tutoriaId,
      estudianteId: solicitud.estudianteId,
      estado: nuevoEstado,
      fechaRespuesta: DateTime.now(), // Aquí registramos la fecha actual
    );

    await _service.actualizarSolicitud(actualizada);

    // Actualiza localmente la lista
    final index = _solicitudes.indexWhere((s) => s.id == solicitudId);
    _solicitudes[index] = actualizada;

    _isLoading = false;
    notifyListeners();
  }

}
