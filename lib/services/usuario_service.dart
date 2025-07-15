import '../models/usuario.dart';
import '../repositories/usuario_repository.dart';

class UsuarioService {
  final UsuarioRepository _usuarioRepository;

  UsuarioService(this._usuarioRepository);

  Future<Usuario?> obtenerUsuarioPorId(String id) {
    return _usuarioRepository.obtenerUsuarioPorId(id);
  }

  Future<void> actualizarUsuario(Usuario usuario) {
    // Aquí podrías añadir validaciones o lógica extra antes de actualizar
    return _usuarioRepository.actualizarUsuario(usuario);
  }
}
