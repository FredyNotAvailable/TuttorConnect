import 'package:tutor_connect/models/aula.dart';
import 'package:tutor_connect/repositories/aula_repository.dart';

class AulaService {
  final AulaRepository _repository;

  AulaService(this._repository);

  Future<List<Aula>> obtenerTodasAulas() {
    return _repository.obtenerTodasAulas();
  }

  Future<Aula?> obtenerAulaPorId(String id) {
    return _repository.obtenerAulaPorId(id);
  }
}
