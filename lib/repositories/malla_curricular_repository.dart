import '../models/malla_curricular.dart';

abstract class MallaCurricularRepository {
  Future<List<MallaCurricular>> obtenerMallasPorCarrera(String carreraId);

  /// Nuevo: devuelve los IDs de materias de una carrera para un ciclo específico
  Future<List<String>> obtenerMateriasPorCarreraYCiclo(String carreraId, int ciclo);
}
