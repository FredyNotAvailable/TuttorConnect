import 'package:cloud_firestore/cloud_firestore.dart';

class AsistenciaTutoria {
  final String id; // puede ser tutoriaId_estudianteId
  final String tutoriaId;
  final String estudianteId;
  final DateTime fechaRegistro;
  final String estado; // 'presente', 'ausente', etc.

  AsistenciaTutoria({
    required this.id,
    required this.tutoriaId,
    required this.estudianteId,
    required this.fechaRegistro,
    required this.estado,
  });

  factory AsistenciaTutoria.fromMap(Map<String, dynamic> map, String id) {
    return AsistenciaTutoria(
      id: id,
      tutoriaId: map['tutoriaId'] ?? '',
      estudianteId: map['estudianteId'] ?? '',
      fechaRegistro: (map['fechaRegistro'] as Timestamp).toDate(),
      estado: map['estado'] ?? 'presente',
    );
  }

  factory AsistenciaTutoria.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AsistenciaTutoria.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'tutoriaId': tutoriaId,
      'estudianteId': estudianteId,
      'fechaRegistro': fechaRegistro,
      'estado': estado,
    };
  }
}
