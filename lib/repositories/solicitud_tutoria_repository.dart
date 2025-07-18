import 'package:tutor_connect/models/solicitud_tutoria.dart';

abstract class SolicitudTutoriaRepository {
  /// Obtiene todas las solicitudes asociadas a una tutoría específica.
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorTutoria(String tutoriaId);

  /// Obtiene todas las solicitudes asociadas a un estudiante específico.
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorEstudiante(String estudianteId);

  /// Obtiene una solicitud por su ID.
  Future<SolicitudTutoria?> obtenerSolicitudPorId(String id);

  /// Crea una solicitud individual.
  Future<void> crearSolicitud(SolicitudTutoria solicitud);

  /// Actualiza una solicitud existente.
  Future<void> actualizarSolicitud(SolicitudTutoria solicitud);

  /// Crea múltiples solicitudes en batch (útil para crear solicitudes masivas).
  Future<void> crearSolicitudes(List<SolicitudTutoria> solicitudes);

  /// Agrega un estudiante a la tutoría (actualiza estudiantesIds).
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId);

}
