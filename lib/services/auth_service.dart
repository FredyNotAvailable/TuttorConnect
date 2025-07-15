import 'package:tutor_connect/models/usuario.dart';
import '../repositories/auth_repository.dart';

class AuthService {
  final AuthRepository _authRepository;

  AuthService(this._authRepository);

  Future<Usuario?> login(String email, String password) {
    return _authRepository.signInWithEmailAndPassword(email, password);
  }

  Future<void> logout() {
    return _authRepository.signOut();
  }

  Future<Usuario?> getCurrentUser() {
    return _authRepository.getCurrentUser();
  }
}
