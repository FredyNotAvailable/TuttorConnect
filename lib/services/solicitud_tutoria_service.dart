import 'package:tutor_connect/models/solicitud_tutoria.dart';
import 'package:tutor_connect/repositories/solicitud_tutoria_repository.dart';

class SolicitudTutoriaService {
  final SolicitudTutoriaRepository _repository;

  SolicitudTutoriaService(this._repository);

  Future<List<SolicitudTutoria>> obtenerSolicitudesPorTutoria(String tutoriaId) {
    return _repository.obtenerSolicitudesPorTutoria(tutoriaId);
  }

  Future<List<SolicitudTutoria>> obtenerSolicitudesPorEstudiante(String estudianteId) {
    return _repository.obtenerSolicitudesPorEstudiante(estudianteId);
  }

  Future<SolicitudTutoria?> obtenerSolicitudPorId(String id) {
    return _repository.obtenerSolicitudPorId(id);
  }

  Future<void> crearSolicitud(SolicitudTutoria solicitud) {
    return _repository.crearSolicitud(solicitud);
  }

  Future<void> actualizarSolicitud(SolicitudTutoria solicitud) {
    return _repository.actualizarSolicitud(solicitud);
  }
}
