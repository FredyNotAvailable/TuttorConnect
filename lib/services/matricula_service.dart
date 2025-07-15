import '../models/matricula.dart';
import '../repositories/matricula_repository.dart';

class MatriculaService {
  final MatriculaRepository _repository;

  MatriculaService(this._repository);

  Future<Matricula?> cargarMatriculaPorUsuario(String usuarioId) {
    return _repository.obtenerMatriculaPorUsuarioId(usuarioId);
  }
}
