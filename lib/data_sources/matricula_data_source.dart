import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/matricula.dart';
import 'package:tutor_connect/repositories/matricula_repository.dart';

class MatriculaDataSource implements MatriculaRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _matriculaPath = 'matriculas';
  final String _mallaPath = 'mallas_curriculares';

  @override
  Future<Matricula?> obtenerMatriculaPorUsuarioId(String usuarioId) async {
    print('[DEBUG] UsuarioId recibido: $usuarioId');
    final query = await _firestore
        .collection(_matriculaPath)
        .where('usuarioId', isEqualTo: usuarioId)
        .where('matriculaActiva', isEqualTo: true)
        .limit(1)
        .get();

    print('[DEBUG] obtenerMatriculaPorUsuarioId: docs encontrados = ${query.docs.length}');

    if (query.docs.isEmpty) return null;

    print('[DEBUG] Matricula doc data: ${query.docs.first.data()}');

    return Matricula.fromFirestore(query.docs.first);
  }

  @override
  Future<List<String>> obtenerEstudiantesPorMateriaYCiclo(String materiaId, int ciclo) async {
    final matriculasSnapshot = await _firestore
        .collection(_matriculaPath)
        .where('matriculaActiva', isEqualTo: true)
        .where('ciclo', isEqualTo: ciclo)
        .get();

    print('[DEBUG] obtenerEstudiantesPorMateriaYCiclo: matrículas encontradas en ciclo $ciclo = ${matriculasSnapshot.docs.length}');

    List<String> estudiantesIds = [];

    for (final matriculaDoc in matriculasSnapshot.docs) {
      final matriculaData = matriculaDoc.data();
      print('[DEBUG] Matricula doc id: ${matriculaDoc.id}, data: $matriculaData');

      final carreraId = matriculaData['carreraId'] as String?;
      final usuarioId = matriculaData['usuarioId'] as String?;

      if (carreraId == null || usuarioId == null) {
        print('[WARN] carreraId o usuarioId es null, se omite matrícula');
        continue;
      }

      // 🔧 Cambio aquí: buscar malla por campo carreraId
      final mallaQuery = await _firestore
          .collection(_mallaPath)
          .where('carreraId', isEqualTo: carreraId)
          .limit(1)
          .get();

      if (mallaQuery.docs.isEmpty) {
        print('[WARN] No existe malla curricular para carreraId: $carreraId');
        continue;
      }

      final mallaData = mallaQuery.docs.first.data();
      print('[DEBUG] Malla curricular data para carreraId $carreraId: $mallaData');

      final materiasPorCicloRaw = mallaData['materiasPorCiclo'];
      if (materiasPorCicloRaw == null) {
        print('[WARN] materiasPorCiclo es null en malla curricular de carreraId: $carreraId');
        continue;
      }

      final materiasPorCiclo = Map<String, dynamic>.from(materiasPorCicloRaw);

      final List<dynamic>? materiasDelCiclo = materiasPorCiclo[ciclo.toString()];
      print('[DEBUG] materiasDelCiclo para ciclo $ciclo: $materiasDelCiclo');

      if (materiasDelCiclo == null) {
        print('[WARN] No hay materias para ciclo $ciclo en carreraId: $carreraId');
        continue;
      }

      final contieneMateria = materiasDelCiclo.any((mat) {
        if (mat is String) return mat == materiaId;
        if (mat is Map<String, dynamic>) return mat['id'] == materiaId;
        return false;
      });

      print('[DEBUG] ¿Contiene materia $materiaId? $contieneMateria');

      if (contieneMateria) {
        estudiantesIds.add(usuarioId);
      }
    }

    print('[DEBUG] estudiantesIds encontrados: $estudiantesIds');

    return estudiantesIds;
  }
}
