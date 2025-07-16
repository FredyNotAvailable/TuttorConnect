import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/malla_curricular.dart';
import '../repositories/malla_curricular_repository.dart';

class MallaCurricularDataSource implements MallaCurricularRepository {
  final _ref = FirebaseFirestore.instance.collection('mallas_curriculares');

  @override
  Future<List<MallaCurricular>> obtenerMallasPorCarrera(String carreraId) async {
    final snapshot = await _ref.where('carreraId', isEqualTo: carreraId).get();

    return snapshot.docs
        .map((doc) => MallaCurricular.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<String>> obtenerMateriasPorCarreraYCiclo(String carreraId, int ciclo) async {
    final snapshot = await _ref
        .where('carreraId', isEqualTo: carreraId)
        .get();

    if (snapshot.docs.isEmpty) return [];

    // Suponemos que solo hay una malla activa por carrera
    final malla = MallaCurricular.fromFirestore(snapshot.docs.first);

    final cicloKey = ciclo.toString();

    return malla.materiasPorCiclo[cicloKey] ?? [];
  }
}
