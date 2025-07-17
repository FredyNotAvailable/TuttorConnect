import 'package:cloud_firestore/cloud_firestore.dart';

class Tutoria {
  final String id;
  final String docenteId;
  final String materiaId;
  final String aulaId;
  final DateTime fecha;
  final String horaInicio; // Formato "HH:mm"
  final String horaFin;    // Formato "HH:mm"
  final String tema;
  final List<String> estudiantesIds;
  final String estado; // 'activa', 'finalizada', 'cancelada'

  Tutoria({
    required this.id,
    required this.docenteId,
    required this.materiaId,
    required this.aulaId,
    required this.fecha,
    required this.horaInicio,
    required this.horaFin,
    required this.tema,
    required this.estudiantesIds,
    required this.estado,
  });

  factory Tutoria.fromMap(Map<String, dynamic> map, String id) {
    return Tutoria(
      id: id,
      docenteId: map['docenteId'] ?? '',
      materiaId: map['materiaId'] ?? '',
      aulaId: map['aulaId'] ?? '',
      fecha: (map['fecha'] as Timestamp).toDate(),
      horaInicio: map['horaInicio'] ?? '',
      horaFin: map['horaFin'] ?? '',
      tema: map['tema'] ?? '',
      estudiantesIds: List<String>.from(map['estudiantesIds'] ?? []),
      estado: map['estado'] ?? 'activa',
    );
  }

  factory Tutoria.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Tutoria.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'docenteId': docenteId,
      'materiaId': materiaId,
      'aulaId': aulaId,
      'fecha': fecha,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'tema': tema,
      'estudiantesIds': estudiantesIds,
      'estado': estado,
    };
  }
}
