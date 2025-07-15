import '../models/carrera.dart';

abstract class CarreraRepository {
  Future<Carrera> obtenerCarreraPorId(String id);
}
