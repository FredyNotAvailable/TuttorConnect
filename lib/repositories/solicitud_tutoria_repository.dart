import 'package:tutor_connect/models/solicitud_tutoria.dart';

abstract class SolicitudTutoriaRepository {
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorTutoria(String tutoriaId);
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorEstudiante(String estudianteId);
  Future<SolicitudTutoria?> obtenerSolicitudPorId(String id);

  Future<void> crearSolicitud(SolicitudTutoria solicitud);
  Future<void> actualizarSolicitud(SolicitudTutoria solicitud);
}
