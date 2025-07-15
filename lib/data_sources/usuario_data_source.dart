import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/usuario.dart';
import '../repositories/usuario_repository.dart';

class UsuarioDataSource implements UsuarioRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'usuarios';

  @override
  Future<Usuario?> obtenerUsuarioPorId(String id) async {
    final doc = await _firestore.collection(_collectionPath).doc(id).get();
    if (!doc.exists) return null;

    return Usuario.fromFirestore(doc);
  }

  @override
  Future<void> actualizarUsuario(Usuario usuario) async {
    await _firestore.collection(_collectionPath).doc(usuario.id).update(usuario.toMap());
  }
}
