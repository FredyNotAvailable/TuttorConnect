import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/aula.dart';
import 'package:tutor_connect/repositories/aula_repository.dart';

class AulaDataSource implements AulaRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('aulas');

  @override
  Future<List<Aula>> obtenerTodasAulas() async {
    final querySnapshot = await _collection.get();
    return querySnapshot.docs.map((doc) => Aula.fromFirestore(doc)).toList();
  }

  @override
  Future<Aula?> obtenerAulaPorId(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return Aula.fromFirestore(doc);
    }
    return null;
  }
}
