import 'package:cloud_firestore/cloud_firestore.dart';

class HorarioDisponible {
  final String id;
  final String docenteId;
  final String diaSemana; // Ej: "lunes", "martes"
  final String horaInicio; // Ej: "14:00"
  final String horaFin; // Ej: "16:00"
  final bool activo;

  HorarioDisponible({
    required this.id,
    required this.docenteId,
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.activo,
  });

  factory HorarioDisponible.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HorarioDisponible(
      id: doc.id,
      docenteId: data['docenteId'] ?? '',
      diaSemana: data['diaSemana'] ?? '',
      horaInicio: data['horaInicio'] ?? '',
      horaFin: data['horaFin'] ?? '',
      activo: data['activo'] ?? true,
    );
  }

  factory HorarioDisponible.fromMap(Map<String, dynamic> map, String id) {
    return HorarioDisponible(
      id: id,
      docenteId: map['docenteId'] ?? '',
      diaSemana: map['diaSemana'] ?? '',
      horaInicio: map['horaInicio'] ?? '',
      horaFin: map['horaFin'] ?? '',
      activo: map['activo'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docenteId': docenteId,
      'diaSemana': diaSemana,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'activo': activo,
    };
  }
}
