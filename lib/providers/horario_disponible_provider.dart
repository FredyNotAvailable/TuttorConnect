import 'package:flutter/material.dart';
import '../models/horario_disponible.dart';
import '../services/horario_disponible_service.dart';

class HorarioDisponibleProvider extends ChangeNotifier {
  final HorarioDisponibleService _service;

  List<HorarioDisponible> _horarios = [];
  bool _cargando = false;
  String? _error;

  HorarioDisponibleProvider(this._service);

  List<HorarioDisponible> get horarios => _horarios;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarHorariosPorDocente(String docenteId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _horarios = await _service.obtenerHorariosPorDocente(docenteId);
    } catch (e) {
      _error = 'Error al cargar horarios: $e';
    }

    _cargando = false;
    notifyListeners();
  }

  Future<void> agregarHorario(HorarioDisponible horario) async {
    try {
      await _service.agregarHorario(horario);
      _horarios.add(horario);
      notifyListeners();
    } catch (e) {
      _error = 'Error al agregar horario: $e';
      notifyListeners();
    }
  }

  Future<void> actualizarHorario(HorarioDisponible horario) async {
    try {
      await _service.actualizarHorario(horario);
      final index = _horarios.indexWhere((h) => h.id == horario.id);
      if (index != -1) {
        _horarios[index] = horario;
        notifyListeners();
      }
    } catch (e) {
      _error = 'Error al actualizar horario: $e';
      notifyListeners();
    }
  }

  Future<void> eliminarHorario(String id) async {
    try {
      await _service.eliminarHorario(id);
      _horarios.removeWhere((h) => h.id == id);
      notifyListeners();
    } catch (e) {
      _error = 'Error al eliminar horario: $e';
      notifyListeners();
    }
  }
}
