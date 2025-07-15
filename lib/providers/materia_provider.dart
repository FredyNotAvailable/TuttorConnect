import 'package:flutter/material.dart';
import '../models/materia.dart';
import '../services/materia_service.dart';

class MateriaProvider extends ChangeNotifier {
  final MateriaService _materiaService;

  MateriaProvider(this._materiaService);

  List<Materia> _materias = [];
  List<Materia> get materias => _materias;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  Future<void> cargarMaterias() async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _materias = await _materiaService.obtenerMaterias();
    } catch (e) {
      _error = 'Error al cargar materias: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<void> cargarMateriasPorIds(List<String> ids) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _materias = await _materiaService.obtenerMateriasPorIds(ids);
    } catch (e) {
      _error = 'Error al cargar materias por IDs: $e';
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  Future<Materia?> obtenerMateriaPorId(String id) async {
    try {
      return await _materiaService.obtenerMateriaPorId(id);
    } catch (e) {
      _error = 'Error al obtener materia por ID: $e';
      notifyListeners();
      return null;
    }
  }

  void setMaterias(List<Materia> materias) {
    _materias = materias;
    notifyListeners();
  }

  void limpiarMaterias() {
    _materias = [];
    notifyListeners();
  }
}
