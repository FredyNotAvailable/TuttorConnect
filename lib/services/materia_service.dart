import '../models/materia.dart';
import '../data_sources/materia_data_source.dart';

class MateriaService {
  final MateriaDataSource _materiaDataSource;

  MateriaService(this._materiaDataSource);

  Future<List<Materia>> obtenerMaterias() {
    return _materiaDataSource.obtenerMaterias();
  }

  Future<Materia?> obtenerMateriaPorId(String id) {
    return _materiaDataSource.obtenerMateriaPorId(id);
  }

  Future<List<Materia>> obtenerMateriasPorIds(List<String> ids) {
    return _materiaDataSource.obtenerMateriasPorIds(ids);
  }
}
