import 'package:flutter/material.dart';
import '../models/carrera.dart';
import '../services/carrera_service.dart';

class CarreraProvider extends ChangeNotifier {
  final CarreraService _service;
  final List<Carrera> _carreras = [];

  Carrera? _carrera;
  Carrera? get carrera => _carrera;

  bool _cargando = false;
  bool get cargando => _cargando;

  String? _error;
  String? get error => _error;

  CarreraProvider(this._service);

  String? _carreraIdCargada;

  Future<void> cargarCarrera(String id) async {
    if (_carreraIdCargada == id) return; // Ya cargada esta carrera
    _carreraIdCargada = id;

    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _carrera = await _service.obtenerCarreraPorId(id);
    } catch (e) {
      _error = 'Error al cargar carrera: $e';
    }

    _cargando = false;
    notifyListeners();
  }


  // Este es el método que falta
  Carrera? obtenerCarreraPorId(String? id) {
    if (id == null) return null;
    try {
      return _carreras.firstWhere((c) => c.id == id);
    } catch (e) {
      return null; // Si no encuentra la carrera
    }
  }
}
