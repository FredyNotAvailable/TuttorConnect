import 'package:cloud_firestore/cloud_firestore.dart';

class MallaCurricular {
  final String id;
  final String carreraId;
  final int ciclos; // número total de ciclos de la malla
  final Map<String, List<String>> materiasPorCiclo; // claves ciclo como String, valor lista de IDs materia
  final Timestamp createdAt;

  MallaCurricular({
    required this.id,
    required this.carreraId,
    required this.ciclos,
    required this.materiasPorCiclo,
    required this.createdAt,
  });

  // Factory para crear desde Map + id
  factory MallaCurricular.fromMap(Map<String, dynamic> map, String id) {
    final Map<String, dynamic> materiasRaw = map['materiasPorCiclo'] ?? {};
    Map<String, List<String>> materiasCiclo = materiasRaw.map((key, value) {
      List<String> materias = [];
      if (value is List) {
        materias = value.map((e) => e.toString()).toList();
      }
      return MapEntry(key, materias);
    });

    return MallaCurricular(
      id: id,
      carreraId: map['carreraId'] ?? '',
      ciclos: map['ciclos'] ?? 0,
      materiasPorCiclo: materiasCiclo,
      createdAt: map['createdAt'] ?? Timestamp.now(),
    );
  }

  // Factory para crear desde DocumentSnapshot
  factory MallaCurricular.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MallaCurricular.fromMap(data, doc.id);
  }

  // Convertir a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'carreraId': carreraId,
      'ciclos': ciclos,
      'materiasPorCiclo': materiasPorCiclo,
      'createdAt': createdAt,
    };
  }
}
