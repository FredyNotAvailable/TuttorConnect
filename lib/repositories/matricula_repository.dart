import 'package:tutor_connect/models/matricula.dart';

abstract class MatriculaRepository {
  Future<Matricula?> obtenerMatriculaPorUsuarioId(String usuarioId);
}
