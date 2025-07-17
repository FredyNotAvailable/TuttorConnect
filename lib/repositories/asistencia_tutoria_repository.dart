import 'package:tutor_connect/models/asistencia_tutoria.dart';

abstract class AsistenciaTutoriaRepository {
  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorTutoria(String tutoriaId);
  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorEstudiante(String estudianteId);
  Future<AsistenciaTutoria?> obtenerAsistenciaPorId(String id);

  Future<void> registrarAsistencia(AsistenciaTutoria asistencia);
  Future<void> actualizarAsistencia(AsistenciaTutoria asistencia);
}
