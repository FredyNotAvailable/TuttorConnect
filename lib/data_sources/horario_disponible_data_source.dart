import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/horario_disponible.dart';
import '../repositories/horario_disponible_repository.dart';

class HorarioDisponibleDataSource implements HorarioDisponibleRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('horarios_disponibles');

  @override
  Future<List<HorarioDisponible>> obtenerHorariosPorDocente(String docenteId) async {
    final querySnapshot = await _collection
        .where('docenteId', isEqualTo: docenteId)
        .get();

    return querySnapshot.docs
        .map((doc) => HorarioDisponible.fromFirestore(doc))
        .toList();
  }

  @override
  Future<void> agregarHorario(HorarioDisponible horario) async {
    await _collection.add(horario.toMap());
  }

  @override
  Future<void> actualizarHorario(HorarioDisponible horario) async {
    await _collection.doc(horario.id).update(horario.toMap());
  }

  @override
  Future<void> eliminarHorario(String id) async {
    await _collection.doc(id).delete();
  }
}
