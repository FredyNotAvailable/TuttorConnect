import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/solicitud_tutoria.dart';
import 'package:tutor_connect/repositories/solicitud_tutoria_repository.dart';

class SolicitudTutoriaDataSource implements SolicitudTutoriaRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('solicitudes_tutoria');
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorTutoria(String tutoriaId) async {
    final querySnapshot =
        await _collection.where('tutoriaId', isEqualTo: tutoriaId).get();
    return querySnapshot.docs
        .map((doc) => SolicitudTutoria.fromFirestore(doc))
        .toList();
  }

  @override
  Future<List<SolicitudTutoria>> obtenerSolicitudesPorEstudiante(String estudianteId) async {
    final querySnapshot =
        await _collection.where('estudianteId', isEqualTo: estudianteId).get();
    return querySnapshot.docs
        .map((doc) => SolicitudTutoria.fromFirestore(doc))
        .toList();
  }

  @override
  Future<SolicitudTutoria?> obtenerSolicitudPorId(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return SolicitudTutoria.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<void> crearSolicitud(SolicitudTutoria solicitud) async {
    final data = solicitud.toMap();
    // Si no tiene createdAt, asignar la fecha actual
    if (data['createdAt'] == null) {
      data['createdAt'] = Timestamp.now();
    }
    await _collection.doc(solicitud.id).set(data);
  }

  @override
  Future<void> actualizarSolicitud(SolicitudTutoria solicitud) async {
    await _collection.doc(solicitud.id).update(solicitud.toMap());
  }

  @override
  Future<void> crearSolicitudes(List<SolicitudTutoria> solicitudes) async {
    final batch = _firestore.batch();

    for (final solicitud in solicitudes) {
      final docRef = _collection.doc(solicitud.id);
      final data = solicitud.toMap();
      if (data['createdAt'] == null) {
        data['createdAt'] = Timestamp.now();
      }
      batch.set(docRef, data);
    }

    await batch.commit();
  }

  @override
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId) async {
    final docRef = FirebaseFirestore.instance.collection('tutorias').doc(tutoriaId);
    await docRef.update({
      'estudiantesIds': FieldValue.arrayUnion([estudianteId])
    });
  }
}
