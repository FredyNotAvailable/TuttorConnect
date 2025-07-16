import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/plan_docente.dart';
import '../repositories/plan_docente_repository.dart';

class PlanDocenteDataSource implements PlanDocenteRepository {
  final CollectionReference _planDocenteRef =
      FirebaseFirestore.instance.collection('planes_docentes');

  @override
  Future<PlanDocente?> obtenerPlanPorDocenteId(String docenteId) async {
    final querySnapshot = await _planDocenteRef
        .where('docenteId', isEqualTo: docenteId)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return null;
    }

    final doc = querySnapshot.docs.first;
    return PlanDocente.fromMap(doc.data() as Map<String, dynamic>, doc.id);
  }

}
