import 'package:cloud_firestore/cloud_firestore.dart';

class Carrera {
  final String id;
  final String nombre;

  Carrera({
    required this.id,
    required this.nombre,
  });

  // Factory para crear desde un Map + id
  factory Carrera.fromMap(Map<String, dynamic> map, String id) {
    return Carrera(
      id: id,
      nombre: map['nombre'] ?? 'Nombre no disponible',
    );
  }

  // Factory para crear desde DocumentSnapshot de Firestore
  factory Carrera.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Carrera(
      id: doc.id,
      nombre: data['nombre'] ?? 'Nombre no disponible',
    );
  }

  // Convierte a Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }
}
