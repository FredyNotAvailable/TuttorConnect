import 'package:flutter/material.dart';
import 'package:tutor_connect/models/usuario.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  Usuario? _user;
  bool _isLoading = false;
  String? _error;

  AuthProvider(this._authService);

  Usuario? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final loggedUser = await _authService.login(email, password);
      if (loggedUser != null) {
        _user = loggedUser;

        // Imprime el rol y nombre del usuario
        // ignore: avoid_print
        print('🔷 Usuario logueado como rol: ${_user!.rol}, nombre: ${_user!.nombre ?? ''}');

      } else {
        _error = 'Usuario no encontrado o contraseña incorrecta';
      }
    } catch (e) {
      _error = 'Error: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCurrentUser() async {
    _isLoading = true;
    notifyListeners();

    try {
      final currentUser = await _authService.getCurrentUser();
      _user = currentUser;
    } catch (e) {
      _error = 'Error cargando usuario actual: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}
