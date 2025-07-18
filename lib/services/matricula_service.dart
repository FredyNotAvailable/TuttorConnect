import '../models/matricula.dart';
import '../repositories/matricula_repository.dart';

class MatriculaService {
  final MatriculaRepository _repository;

  MatriculaService(this._repository);

  Future<Matricula?> cargarMatriculaPorUsuario(String usuarioId) {
    return _repository.obtenerMatriculaPorUsuarioId(usuarioId);
  }

  // Nuevo método para obtener estudiantes por materia y ciclo
  Future<List<String>> obtenerEstudiantesPorMateriaYCiclo(String materiaId, int ciclo) {
    return _repository.obtenerEstudiantesPorMateriaYCiclo(materiaId, ciclo);
  }
}
