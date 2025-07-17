import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/asistencia_tutoria.dart';
import 'package:tutor_connect/repositories/asistencia_tutoria_repository.dart';

class AsistenciaTutoriaDataSource implements AsistenciaTutoriaRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('asistencias_tutoria');

  @override
  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorTutoria(String tutoriaId) async {
    final querySnapshot =
        await _collection.where('tutoriaId', isEqualTo: tutoriaId).get();
    return querySnapshot.docs
        .map((doc) => AsistenciaTutoria.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<AsistenciaTutoria>> obtenerAsistenciasPorEstudiante(String estudianteId) async {
    final querySnapshot =
        await _collection.where('estudianteId', isEqualTo: estudianteId).get();
    return querySnapshot.docs
        .map((doc) => AsistenciaTutoria.fromFirestore(doc))
        .toList();
  }

  @override
  Future<AsistenciaTutoria?> obtenerAsistenciaPorId(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return AsistenciaTutoria.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> registrarAsistencia(AsistenciaTutoria asistencia) async {
    await _collection.doc(asistencia.id).set(asistencia.toMap());
  }

  @override
  Future<void> actualizarAsistencia(AsistenciaTutoria asistencia) async {
    await _collection.doc(asistencia.id).update(asistencia.toMap());
  }
}
