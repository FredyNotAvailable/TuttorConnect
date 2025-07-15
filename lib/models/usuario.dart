import 'package:cloud_firestore/cloud_firestore.dart';
import 'rol.dart';

class Usuario {
  final String id;
  final String correo;
  final String? nombre;
  final String? telefono;
  final RolUsuario rol; // enum
  final Timestamp? createdAt;

  Usuario({
    required this.id,
    required this.correo,
    this.nombre,
    this.telefono,
    required this.rol,
    this.createdAt,
  });

  // Factory para crear desde Map + id
  factory Usuario.fromMap(Map<String, dynamic> map, {required String id}) {
    return Usuario(
      id: id,
      correo: map['correo'] ?? '',
      nombre: map['nombre'],
      telefono: map['telefono'],
      rol: RolUsuario.values.firstWhere(
        (e) => e.name == map['rol'],
        orElse: () => RolUsuario.estudiante, // valor por defecto
      ),
      createdAt: map['createdAt'],
    );
  }

  // Factory para crear desde DocumentSnapshot de Firestore
  factory Usuario.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Usuario(
      id: doc.id,
      correo: data['correo'] ?? '',
      nombre: data['nombre'],
      telefono: data['telefono'],
      rol: RolUsuario.values.firstWhere(
        (e) => e.name == data['rol'],
        orElse: () => RolUsuario.estudiante,
      ),
      createdAt: data['createdAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'correo': correo,
      'nombre': nombre,
      'telefono': telefono,
      'rol': rol.name,
      'createdAt': createdAt ?? FieldValue.serverTimestamp(),
    };
  }
}
