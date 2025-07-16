class PlanDocente {
  final String id;
  final String docenteId;
  final String carreraId;  // <-- nuevo campo
  final Map<String, List<String>> materiasPorCiclo;

  PlanDocente({
    required this.id,
    required this.docenteId,
    required this.carreraId,
    required this.materiasPorCiclo,
  });

  factory PlanDocente.fromMap(Map<String, dynamic> map, String id) {
    final materiasRaw = (map['materiasPorCiclo'] ?? <String, dynamic>{}) as Map<String, dynamic>;
    
    final materiasPorCiclo = materiasRaw.map<String, List<String>>((key, value) {
      final listaMaterias = (value as List<dynamic>).map((e) => e.toString()).toList();
      return MapEntry(key, listaMaterias);
    });

    return PlanDocente(
      id: id,
      docenteId: map['docenteId'] ?? '',
      carreraId: map['carreraId'] ?? '',
      materiasPorCiclo: materiasPorCiclo,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'docenteId': docenteId,
      'carreraId': carreraId,
      'materiasPorCiclo': materiasPorCiclo,
    };
  }
}
