import '../models/usuario.dart';

abstract class UsuarioRepository {
  Future<Usuario?> obtenerUsuarioPorId(String id);
  Future<void> actualizarUsuario(Usuario usuario);
}
