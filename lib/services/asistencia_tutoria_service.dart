import 'package:tutor_connect/models/asistencia_tutoria.dart';
import 'package:tutor_connect/repositories/asistencia_tutoria_repository.dart';

class AsistenciaTutoriaService {
  final AsistenciaTutoriaRepository _repository;

  AsistenciaTutoriaService(this._repository);

  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorTutoria(String tutoriaId) {
    return _repository.obtenerAsistenciasPorTutoria(tutoriaId);
  }

  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorEstudiante(String estudianteId) {
    return _repository.obtenerAsistenciasPorEstudiante(estudianteId);
  }

  Future<AsistenciaTutoria?> obtenerAsistenciaPorId(String id) {
    return _repository.obtenerAsistenciaPorId(id);
  }

  Future<void> registrarAsistencia(AsistenciaTutoria asistencia) {
    return _repository.registrarAsistencia(asistencia);
  }

  Future<void> actualizarAsistencia(AsistenciaTutoria asistencia) {
    return _repository.actualizarAsistencia(asistencia);
  }
}
