import 'package:cloud_firestore/cloud_firestore.dart';

class Matricula {
  final String id;
  final String usuarioId;
  final String carreraId;
  final int ciclo;
  final List<String> materiasInscritas;
  final bool matriculaActiva;

  Matricula({
    required this.id,
    required this.usuarioId,
    required this.carreraId,
    required this.ciclo,
    required this.materiasInscritas,
    required this.matriculaActiva,
  });

  // Factory para crear desde DocumentSnapshot de Firestore
  factory Matricula.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Matricula(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? '',
      carreraId: data['carreraId'] ?? '',
      ciclo: data['ciclo'] ?? 0,
      materiasInscritas: List<String>.from(data['materiasInscritas'] ?? []),
      matriculaActiva: data['matriculaActiva'] ?? false,
    );
  }

  // Factory para crear desde un Map + id, útil para otras fuentes de datos
  factory Matricula.fromMap(Map<String, dynamic> data, String id) {
    return Matricula(
      id: id,
      usuarioId: data['usuarioId'] ?? '',
      carreraId: data['carreraId'] ?? '',
      ciclo: data['ciclo'] ?? 0,
      materiasInscritas: List<String>.from(data['materiasInscritas'] ?? []),
      matriculaActiva: data['matriculaActiva'] ?? false,
    );
  }

  // Convierte la instancia a Map para guardar en Firestore o enviar a API
  Map<String, dynamic> toMap() {
    return {
      'usuarioId': usuarioId,
      'carreraId': carreraId,
      'ciclo': ciclo,
      'materiasInscritas': materiasInscritas,
      'matriculaActiva': matriculaActiva,
    };
  }
}
