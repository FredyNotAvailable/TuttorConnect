import '../models/carrera.dart';
import '../repositories/carrera_repository.dart';

class CarreraService {
  final CarreraRepository _repository;

  CarreraService(this._repository);

  Future<Carrera?> obtenerCarreraPorId(String id) async {
    try {
      return await _repository.obtenerCarreraPorId(id);
    } catch (e) {
      print('Error en CarreraService: $e');
      return null;
    }
  }
}
