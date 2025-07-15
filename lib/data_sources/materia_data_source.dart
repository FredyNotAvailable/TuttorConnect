import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/repositories/materia_repository.dart';
import '../models/materia.dart';

class MateriaDataSource implements MateriaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionName = 'materias'; // Ajusta si tu colección tiene otro nombre

  @override
  Future<List<Materia>> obtenerMaterias() async {
    final querySnapshot = await _firestore.collection(collectionName).get();
    return querySnapshot.docs
        .map((doc) => Materia.fromFirestore(doc))
        .toList();
  }

  @override
  Future<Materia?> obtenerMateriaPorId(String id) async {
    final docSnapshot = await _firestore.collection(collectionName).doc(id).get();
    if (docSnapshot.exists) {
      return Materia.fromFirestore(docSnapshot);
    } else {
      return null;
    }
  }

  @override
  Future<List<Materia>> obtenerMateriasPorIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    final querySnapshot = await _firestore
        .collection(collectionName)
        .where(FieldPath.documentId, whereIn: ids)
        .get();

    return querySnapshot.docs
        .map((doc) => Materia.fromFirestore(doc))
        .toList();
  }
}
