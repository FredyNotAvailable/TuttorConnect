import '../models/malla_curricular.dart';
import '../repositories/malla_curricular_repository.dart';

class MallaCurricularService {
  final MallaCurricularRepository _repository;

  MallaCurricularService(this._repository);

  Future<MallaCurricular?> obtenerMallaDeCarrera(String carreraId) async {
    final mallas = await _repository.obtenerMallasPorCarrera(carreraId);

    if (mallas.isEmpty) return null;

    // Por ahora devolvemos solo la primera malla que encuentre
    // En un futuro podrías permitir elegir entre varias
    return mallas.first;
  }

    Future<List<String>> obtenerMateriasPorCarreraYCiclo(
      String carreraId, int ciclo) {
    return _repository.obtenerMateriasPorCarreraYCiclo(carreraId, ciclo);
  }

}
