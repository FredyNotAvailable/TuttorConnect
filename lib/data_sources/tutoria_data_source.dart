import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/tutoria.dart';
import 'package:tutor_connect/repositories/tutoria_repository.dart';

class TutoriaDataSource implements TutoriaRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('tutorias');

  @override
  Future<List<Tutoria>> obtenerTutoriasPorDocente(String docenteId) async {
    final querySnapshot =
        await _collection.where('docenteId', isEqualTo: docenteId).get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasPorEstudiante(String estudianteId) async {
    final querySnapshot = await _collection
        .where('estudiantesIds', arrayContains: estudianteId)
        .get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }

  @override
  Future<Tutoria?> obtenerTutoriaPorId(String id) async {
    final doc = await _collection.doc(id).get();
    if (doc.exists) {
      return Tutoria.fromFirestore(doc);
    }
    return null;
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasActivas() async {
    final querySnapshot =
        await _collection.where('estado', isEqualTo: 'activa').get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }

  @override
  Future<void> crearTutoria(Tutoria tutoria) async {
    await _collection.add(tutoria.toMap());
  }

  @override
  Future<void> actualizarTutoria(Tutoria tutoria) async {
    await _collection.doc(tutoria.id).update(tutoria.toMap());
  }

  @override
  Future<void> cancelarTutoria(String id) async {
    await _collection.doc(id).update({'estado': 'cancelada'});
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasPorMateriaYDocente(
      String materiaId, String docenteId) async {
    final querySnapshot = await _collection
        .where('materiaId', isEqualTo: materiaId)
        .where('docenteId', isEqualTo: docenteId)
        .get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }

  @override
  Future<bool> validarDisponibilidadAula(
      String aulaId, DateTime fecha, String horaInicio, String horaFin) async {
    final querySnapshot = await _collection
        .where('aulaId', isEqualTo: aulaId)
        .where('fecha', isEqualTo: Timestamp.fromDate(fecha))
        .where('estado', isEqualTo: 'activa')
        .get();

    for (var doc in querySnapshot.docs) {
      final tutoria = Tutoria.fromFirestore(doc);

      // Convertir horas a minutos para comparación
      int hi1 = _convertirHoraAMinutos(horaInicio);
      int hf1 = _convertirHoraAMinutos(horaFin);
      int hi2 = _convertirHoraAMinutos(tutoria.horaInicio);
      int hf2 = _convertirHoraAMinutos(tutoria.horaFin);

      // Verificar solapamiento
      bool overlap = (hi1 < hf2) && (hf1 > hi2);
      if (overlap) return false;
    }

    return true;
  }

  int _convertirHoraAMinutos(String hora) {
    final partes = hora.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasPorFecha(DateTime fecha) async {
    final querySnapshot = await _collection
        .where('fecha', isEqualTo: Timestamp.fromDate(fecha))
        .get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }

  @override
  Future<List<Tutoria>> buscarTutoriasPorTema(String tema) async {
    final querySnapshot = await _collection
        .where('tema', isGreaterThanOrEqualTo: tema)
        .where('tema', isLessThanOrEqualTo: tema + '\uf8ff')
        .get();
    return querySnapshot.docs.map((doc) => Tutoria.fromFirestore(doc)).toList();
  }
}
