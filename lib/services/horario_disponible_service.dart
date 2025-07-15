import '../models/horario_disponible.dart';
import '../repositories/horario_disponible_repository.dart';

class HorarioDisponibleService {
  final HorarioDisponibleRepository _repository;

  HorarioDisponibleService(this._repository);

  Future<List<HorarioDisponible>> obtenerHorariosPorDocente(String docenteId) {
    return _repository.obtenerHorariosPorDocente(docenteId);
  }

  Future<void> agregarHorario(HorarioDisponible horario) {
    return _repository.agregarHorario(horario);
  }

  Future<void> actualizarHorario(HorarioDisponible horario) {
    return _repository.actualizarHorario(horario);
  }

  Future<void> eliminarHorario(String id) {
    return _repository.eliminarHorario(id);
  }
}
