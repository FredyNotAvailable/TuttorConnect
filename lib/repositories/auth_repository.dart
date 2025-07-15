import 'package:tutor_connect/models/usuario.dart';

abstract class AuthRepository {
  Future<Usuario?> signInWithEmailAndPassword(String email, String password);
  Future<void> signOut();
  Future<Usuario?> getCurrentUser();
}
