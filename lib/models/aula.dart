import 'package:cloud_firestore/cloud_firestore.dart';

class Aula {
  final String id;
  final String nombre;
  final bool disponible;

  Aula({
    required this.id,
    required this.nombre,
    required this.disponible,
  });

  factory Aula.fromMap(Map<String, dynamic> map, String id) {
    return Aula(
      id: id,
      nombre: map['nombre'] ?? '',
      disponible: map['disponible'] ?? false,
    );
  }

  factory Aula.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Aula.fromMap(data, doc.id);
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'disponible': disponible,
    };
  }
}
