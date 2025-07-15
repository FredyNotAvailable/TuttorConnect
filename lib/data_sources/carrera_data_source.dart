import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/carrera.dart';
import '../repositories/carrera_repository.dart';

class CarreraDataSource implements CarreraRepository {
  final _carreraRef = FirebaseFirestore.instance.collection('carreras');

  @override
  Future<Carrera> obtenerCarreraPorId(String id) async {
    final doc = await _carreraRef.doc(id).get();

    if (!doc.exists) {
      throw Exception('Carrera no encontrada');
    }

    return Carrera.fromFirestore(doc);
  }
}
