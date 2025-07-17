import 'package:flutter/material.dart';
import 'package:tutor_connect/models/aula.dart';
import 'package:tutor_connect/services/aula_service.dart';

class AulaProvider extends ChangeNotifier {
  final AulaService _service;

  AulaProvider(this._service);

  List<Aula> _aulas = [];
  List<Aula> get aulas => _aulas;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> cargarAulas() async {
    _isLoading = true;
    notifyListeners();

    _aulas = await _service.obtenerTodasAulas();

    _isLoading = false;
    notifyListeners();
  }
}
