import '../models/materia.dart';

abstract class MateriaRepository {
  Future<List<Materia>> obtenerMaterias();

  Future<Materia?> obtenerMateriaPorId(String id);

  Future<List<Materia>> obtenerMateriasPorIds(List<String> ids);
}
