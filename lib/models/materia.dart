import 'package:cloud_firestore/cloud_firestore.dart';

class Materia {
  final String id;
  final String nombre;

  Materia({
    required this.id,
    required this.nombre,
  });

  // Factory para crear desde DocumentSnapshot de Firestore
  factory Materia.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Materia(
      id: doc.id,
      nombre: data['nombre'] ?? '',
    );
  }

  // Factory para crear desde un Map, útil para otras fuentes de datos
  factory Materia.fromMap(Map<String, dynamic> data, String id) {
    return Materia(
      id: id,
      nombre: data['nombre'] ?? '',
    );
  }

  // Método para convertir la instancia a Map (por ejemplo para guardar en Firestore)
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
    };
  }
}
