import 'package:cloud_firestore/cloud_firestore.dart';
import 'rol.dart';

class Usuario {
  final String id;
  final String correo;
  final String? nombre;
  final String? telefono;
  final RolUsuario rol;  // Ahora es enum y obligatorio
  final Timestamp? createdAt;

  Usuario({
    required this.id,
    required this.correo,
    this.nombre,
    this.telefono,
    required this.rol,
    this.createdAt,
  });
}
