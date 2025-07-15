import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/matricula.dart';
import '../repositories/matricula_repository.dart';

class MatriculaDataSource implements MatriculaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'matriculas';

  @override
  Future<Matricula?> obtenerMatriculaPorUsuarioId(String usuarioId) async {
    final query = await _firestore
        .collection(_collectionPath)
        .where('usuarioId', isEqualTo: usuarioId)
        .where('matriculaActiva', isEqualTo: true)
        .limit(1)
        .get();

    if (query.docs.isEmpty) return null;

    return Matricula.fromFirestore(query.docs.first);
  }
}
