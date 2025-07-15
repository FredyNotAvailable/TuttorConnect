import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/repositories/auth_repository.dart';
import '../models/usuario.dart';
import '../models/rol.dart'; // importa el enum RolUsuario

class AuthDataSource implements AuthRepository {
  final fb.FirebaseAuth _firebaseAuth = fb.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<Usuario?> signInWithEmailAndPassword(String email, String password) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    final fb.User? fbUser = credential.user;
    if (fbUser == null) return null;

    return await _fetchUsuarioPorUid(fbUser.uid, fbUser);
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<Usuario?> getCurrentUser() async {
    final fb.User? fbUser = _firebaseAuth.currentUser;
    if (fbUser == null) return null;

    return await _fetchUsuarioPorUid(fbUser.uid, fbUser);
  }

  // Convierte el string a enum RolUsuario
  RolUsuario _rolFromString(String? rolStr) {
    switch (rolStr?.toLowerCase()) {
      case 'docente':
        return RolUsuario.docente;
      case 'estudiante':
        return RolUsuario.estudiante;
      default:
        return RolUsuario.estudiante; // valor por defecto
    }
  }

  // Función privada que busca en la colección 'usuarios' y crea el Usuario
  Future<Usuario?> _fetchUsuarioPorUid(String uid, fb.User fbUser) async {
    final userDoc = await _firestore.collection('usuarios').doc(uid).get();

    if (!userDoc.exists) return null;

    final data = userDoc.data()!;

    final nombre = data['nombre'] ?? fbUser.displayName ?? '';
    final telefono = data['telefono'] as String?;
    final rol = _rolFromString(data['rol']);

    return Usuario(
      id: uid,
      correo: fbUser.email ?? '',
      nombre: nombre,
      telefono: telefono,
      rol: rol,
      createdAt: data['createdAt'] as Timestamp?,
    );
  }
}
