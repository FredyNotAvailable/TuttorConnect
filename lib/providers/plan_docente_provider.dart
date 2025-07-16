import 'package:flutter/material.dart';
import '../models/plan_docente.dart';
import '../services/plan_docente_service.dart';

class PlanDocenteProvider with ChangeNotifier {
  final PlanDocenteService _service;

  PlanDocenteProvider(this._service);

  PlanDocente? _plan;
  bool _cargando = false;
  String? _error;

  PlanDocente? get plan => _plan;
  bool get cargando => _cargando;
  String? get error => _error;

  Future<void> cargarPlanPorDocenteId(String docenteId) async {
    _cargando = true;
    _error = null;
    notifyListeners();

    try {
      _plan = await _service.obtenerPlanPorDocenteId(docenteId);
    } catch (e) {
      _error = 'Error al cargar el plan docente';
      print(e);
    } finally {
      _cargando = false;
      notifyListeners();
    }
  }

  void limpiar() {
    _plan = null;
    _error = null;
    notifyListeners();
  }
}
