import 'package:flutter/material.dart';
import '../models/malla_curricular.dart';
import '../services/malla_curricular_service.dart';

class MallaCurricularProvider with ChangeNotifier {
  final MallaCurricularService _service;

  MallaCurricularProvider(this._service);

  MallaCurricular? _malla;
  bool _cargando = false;
  String? _error;

  MallaCurricular? get malla => _malla;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarMalla(String carreraId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _malla = await _service.obtenerMallaDeCarrera(carreraId);
    } catch (e) {
      _error = 'Error al cargar la malla curricular';
      print(e);
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _malla = null;
    _error = null;
    notifyListeners();
  }

    Future<List<String>> obtenerMateriasPorCarreraYCiclo(
      String carreraId, int ciclo) async {
    try {
      return await _service.obtenerMateriasPorCarreraYCiclo(carreraId, ciclo);
    } catch (e) {
      print('Error al obtener materias del ciclo: $e');
      return [];
    }
  }
}
