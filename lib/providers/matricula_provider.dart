import 'package:flutter/material.dart';
import '../models/matricula.dart';
import '../services/matricula_service.dart';

class MatriculaProvider extends ChangeNotifier {
  final MatriculaService _service;

  Matricula? _matricula;
  Matricula? get matricula => _matricula;

  List<String> _estudiantesIds = [];
  List<String> get estudiantesIds => _estudiantesIds;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  MatriculaProvider(this._service);

  Future<void> cargarMatricula(String usuarioId) async {
    _setLoading(true);
    _error = null;

    try {
      _matricula = await _service.cargarMatriculaPorUsuario(usuarioId);
    } catch (e) {
      _error = 'Error al cargar matrícula: $e';
    }

    _setLoading(false);
  }

  Future<void> cargarEstudiantesPorMateriaYCiclo(String materiaId, int ciclo) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _estudiantesIds = await _service.obtenerEstudiantesPorMateriaYCiclo(materiaId, ciclo);
      print('MatriculaProvider - estudiantesIds cargados: $_estudiantesIds');
    } catch (e) {
      _error = 'Error al cargar estudiantes: $e';
      print('Error en MatriculaProvider.cargarEstudiantesPorMateriaYCiclo: $e');
      _estudiantesIds = [];
    }

    _cargando = false;
    notifyListeners();
  }


  void _setLoading(bool value) {
    _cargando = value;
    notifyListeners();
  }
}
