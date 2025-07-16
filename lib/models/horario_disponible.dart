import 'package:cloud_firestore/cloud_firestore.dart';

class HorarioDisponible {
  final String id;
  final String docenteId;
  final String materiaId;  // <-- nuevo campo
  final String diaSemana; // Ej: "lunes", "martes"
  final String horaInicio; // Ej: "14:00"
  final String horaFin; // Ej: "16:00"
  final bool disponible;  // cambiado de 'activo' a 'disponible'

  HorarioDisponible({
    required this.id,
    required this.docenteId,
    required this.materiaId,  // <-- inicializamos en constructor
    required this.diaSemana,
    required this.horaInicio,
    required this.horaFin,
    required this.disponible,  // <-- cambiado aquí también
  });

  factory HorarioDisponible.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HorarioDisponible(
      id: doc.id,
      docenteId: data['docenteId'] ?? '',
      materiaId: data['materiaId'] ?? '',
      diaSemana: data['diaSemana'] ?? '',
      horaInicio: data['horaInicio'] ?? '',
      horaFin: data['horaFin'] ?? '',
      disponible: data['disponible'] ?? true,  // cambio aquí
    );
  }

  factory HorarioDisponible.fromMap(Map<String, dynamic> map, String id) {
    return HorarioDisponible(
      id: id,
      docenteId: map['docenteId'] ?? '',
      materiaId: map['materiaId'] ?? '',
      diaSemana: map['diaSemana'] ?? '',
      horaInicio: map['horaInicio'] ?? '',
      horaFin: map['horaFin'] ?? '',
      disponible: map['disponible'] ?? true,  // cambio aquí
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docenteId': docenteId,
      'materiaId': materiaId,
      'diaSemana': diaSemana,
      'horaInicio': horaInicio,
      'horaFin': horaFin,
      'disponible': disponible,  // cambio aquí
    };
  }
}
