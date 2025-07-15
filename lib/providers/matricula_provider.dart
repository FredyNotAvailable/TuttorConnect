import 'package:flutter/material.dart';
import '../models/matricula.dart';
import '../services/matricula_service.dart';

class MatriculaProvider extends ChangeNotifier {
  final MatriculaService _service;

  Matricula? _matricula;
  Matricula? get matricula => _matricula;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  MatriculaProvider(this._service);

  Future<void> cargarMatricula(String usuarioId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _matricula = await _service.cargarMatriculaPorUsuario(usuarioId);
    } catch (e) {
      _error = 'Error al cargar matrícula: $e';
    }

    _cargando = false;
    notifyListeners();
  }
}
