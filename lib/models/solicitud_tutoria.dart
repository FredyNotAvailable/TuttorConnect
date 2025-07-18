import 'package:cloud_firestore/cloud_firestore.dart';

class SolicitudTutoria {
  final String id; // puede ser tutoriaId_estudianteId
  final String tutoriaId;
  final String estudianteId;
  final String estado; // 'pendiente', 'aceptado', 'rechazado'
  final DateTime? fechaRespuesta;
  final DateTime? createdAt; // nuevo campo

  SolicitudTutoria({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
    required this.estado,
    this.fechaRespuesta,
    this.createdAt,
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
      createdAt: map['createdAt'] != null
          ? (map['createdAt'] as Timestamp).toDate()
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
      'fechaRespuesta': fechaRespuesta != null ? Timestamp.fromDate(fechaRespuesta!) : null,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
    };
  }

  SolicitudTutoria copyWith({
    String? id,
    String? tutoriaId,
    String? estudianteId,
    String? estado,
    DateTime? fechaRespuesta,
    DateTime? createdAt,
  }) {
    return SolicitudTutoria(
      id: id ?? this.id,
      tutoriaId: tutoriaId ?? this.tutoriaId,
      estudianteId: estudianteId ?? this.estudianteId,
      estado: estado ?? this.estado,
      fechaRespuesta: fechaRespuesta ?? this.fechaRespuesta,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
