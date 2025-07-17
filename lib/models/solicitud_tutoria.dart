import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitudTutoria {
  final String id; // puede ser tutoriaId_estudianteId
  final String tutoriaId;
  final String estudianteId;
  final String estado; // 'pendiente', 'aceptado', 'rechazado'
  final DateTime? fechaRespuesta;

  SolicitudTutoria({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
    required this.estado,
    this.fechaRespuesta,
  });

  factory SolicitudTutoria.fromMap(Map<String, dynamic> map, String id) {
    return SolicitudTutoria(
      id: id,
      tutoriaId: map['tutoriaId'] ?? '',
      estudianteId: map['estudianteId'] ?? '',
      estado: map['estado'] ?? 'pendiente',
      fechaRespuesta: map['fechaRespuesta'] != null
          ? (map['fechaRespuesta'] as Timestamp).toDate()
          : null,
    );
  }

  factory SolicitudTutoria.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SolicitudTutoria.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'tutoriaId': tutoriaId,
      'estudianteId': estudianteId,
      'estado': estado,
      'fechaRespuesta': fechaRespuesta,
    };
  }
}
