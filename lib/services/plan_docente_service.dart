import '../models/plan_docente.dart';
import '../repositories/plan_docente_repository.dart';

class PlanDocenteService {
  final PlanDocenteRepository _repository;

  PlanDocenteService(this._repository);

  Future<PlanDocente?> obtenerPlanPorDocenteId(String docenteId) async {
    return await _repository.obtenerPlanPorDocenteId(docenteId);
  }
}
