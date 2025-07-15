import '../models/horario_disponible.dart';

abstract class HorarioDisponibleRepository {
  Future<List<HorarioDisponible>> obtenerHorariosPorDocente(String docenteId);

  Future<void> agregarHorario(HorarioDisponible horario);

  Future<void> actualizarHorario(HorarioDisponible horario);

  Future<void> eliminarHorario(String id);
}
