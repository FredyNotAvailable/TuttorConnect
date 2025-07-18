import 'package:tutor_connect/models/matricula.dart';

abstract class MatriculaRepository {
  Future<Matricula?> obtenerMatriculaPorUsuarioId(String usuarioId);

  /// Obtiene los IDs de estudiantes que están matriculados en la materia y ciclo especificados,
  /// considerando la relación materia-ciclo a través de la malla curricular.
  Future<List<String>> obtenerEstudiantesPorMateriaYCiclo(String materiaId, int ciclo);
}
