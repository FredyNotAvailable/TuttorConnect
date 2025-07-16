import '../models/plan_docente.dart';

abstract class PlanDocenteRepository {
  /// Obtiene el plan docente por el ID del docente.
  Future<PlanDocente?> obtenerPlanPorDocenteId(String docenteId);
}
