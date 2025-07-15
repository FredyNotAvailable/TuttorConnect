import 'package:flutter/material.dart';
import '../models/usuario.dart';
import '../services/usuario_service.dart';

class UsuarioProvider extends ChangeNotifier {
  final UsuarioService _usuarioService;

  Usuario? _usuario;
  Usuario? get usuario => _usuario;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  UsuarioProvider(this._usuarioService);

  Future<void> cargarUsuario(String id) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _usuario = await _usuarioService.obtenerUsuarioPorId(id);
    } catch (e) {
      _error = 'Error al cargar usuario: $e';
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> actualizarUsuario(Usuario usuario) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      await _usuarioService.actualizarUsuario(usuario);
      _usuario = usuario;
    } catch (e) {
      _error = 'Error al actualizar usuario: $e';
    }

    _cargando = false;
    notifyListeners();
  }
}
