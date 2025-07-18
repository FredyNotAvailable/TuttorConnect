import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/tutoria.dart';
import 'package:tutor_connect/repositories/tutoria_repository.dart';

class TutoriaDataSource implements TutoriaRepository {
  final CollectionReference _collection =
      FirebaseFirestore.instance.collection('tutorias');

  // Obtener tutorías por docente
  @override
  Future<List<Tutoria>> obtenerTutoriasPorDocente(String docenteId) async {
    final querySnapshot =
        await _collection.where('docenteId', isEqualTo: docenteId).get();
    return querySnapshot.docs.map(Tutoria.fromFirestore).toList();
  }

  // Obtener tutoría por ID
  @override
  Future<Tutoria?> obtenerTutoriaPorId(String id) async {
    final doc = await _collection.doc(id).get();
    return doc.exists ? Tutoria.fromFirestore(doc) : null;
  }

  // Obtener tutorías activas
  @override
  Future<List<Tutoria>> obtenerTutoriasActivas() async {
    final querySnapshot =
        await _collection.where('estado', isEqualTo: 'activa').get();
    return querySnapshot.docs.map(Tutoria.fromFirestore).toList();
  }

  // Crear una nueva tutoría (sin retorno)
  @override
  Future<void> crearTutoria(Tutoria tutoria) async {
    // Si createdAt es nulo o inválido, lo asignamos aquí
    final data = tutoria.toMap();
    if (data['createdAt'] == null) {
      data['createdAt'] = Timestamp.now();
    }
    await _collection.add(data);
  }

  // Nuevo método para crear tutoría y retornar el DocumentReference
  @override
  Future<DocumentReference> crearTutoriaYRetornarDocumento(Tutoria tutoria) async {
    final data = tutoria.toMap();
    if (data['createdAt'] == null) {
      data['createdAt'] = Timestamp.now();
    }
    final docRef = await _collection.add(data);
    return docRef;
  }
  
  // Actualizar tutoría existente
  @override
  Future<void> actualizarTutoria(Tutoria tutoria) async {
    await _collection.doc(tutoria.id).update(tutoria.toMap());
  }

  // Cancelar una tutoría
  @override
  Future<void> cancelarTutoria(String id) async {
    await _collection.doc(id).update({'estado': 'cancelada'});
  }

  // Obtener tutorías por materia y docente
  @override
  Future<List<Tutoria>> obtenerTutoriasPorMateriaYDocente(
      String materiaId, String docenteId) async {
    final querySnapshot = await _collection
        .where('materiaId', isEqualTo: materiaId)
        .where('docenteId', isEqualTo: docenteId)
        .get();
    return querySnapshot.docs.map(Tutoria.fromFirestore).toList();
  }

  // Validar si el aula está disponible en un rango de tiempo
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

      final hi1 = _convertirHoraAMinutos(horaInicio);
      final hf1 = _convertirHoraAMinutos(horaFin);
      final hi2 = _convertirHoraAMinutos(tutoria.horaInicio);
      final hf2 = _convertirHoraAMinutos(tutoria.horaFin);

      if ((hi1 < hf2) && (hf1 > hi2)) return false; // Hay solapamiento
    }

    return true;
  }

  // Convertir una hora (HH:mm) a minutos
  int _convertirHoraAMinutos(String hora) {
    final partes = hora.split(':');
    return int.parse(partes[0]) * 60 + int.parse(partes[1]);
  }

  // Obtener tutorías por fecha exacta
  @override
  Future<List<Tutoria>> obtenerTutoriasPorFecha(DateTime fecha) async {
    final querySnapshot = await _collection
        .where('fecha', isEqualTo: Timestamp.fromDate(fecha))
        .get();
    return querySnapshot.docs.map(Tutoria.fromFirestore).toList();
  }

  // Buscar tutorías por tema (búsqueda con prefijo)
  @override
  Future<List<Tutoria>> buscarTutoriasPorTema(String tema) async {
    final querySnapshot = await _collection
        .where('tema', isGreaterThanOrEqualTo: tema)
        .where('tema', isLessThanOrEqualTo: '$tema\uf8ff')
        .get();
    return querySnapshot.docs.map(Tutoria.fromFirestore).toList();
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasPorIds(List<String> ids) async {
    if (ids.isEmpty) return [];

    List<Tutoria> resultado = [];
    const int chunkSize = 10;

    for (var i = 0; i < ids.length; i += chunkSize) {
      final chunk = ids.sublist(
        i,
        i + chunkSize > ids.length ? ids.length : i + chunkSize,
      );

      final querySnapshot = await _collection
          .where(FieldPath.documentId, whereIn: chunk)
          .get();

      resultado.addAll(querySnapshot.docs.map(Tutoria.fromFirestore).toList());
    }

    return resultado;
  }

  @override
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId) async {
    final docRef = FirebaseFirestore.instance.collection('tutorias').doc(tutoriaId);
    await docRef.update({
      'estudiantesIds': FieldValue.arrayUnion([estudianteId]),
    });
  }

  @override
  Future<List<Tutoria>> obtenerTutoriasPorEstudiante(String estudianteId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tutorias')
        .where('estudiantesIds', arrayContains: estudianteId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Tutoria(
        id: doc.id,
        docenteId: data['docenteId'],
        materiaId: data['materiaId'],
        aulaId: data['aulaId'],
        fecha: (data['fecha'] as Timestamp).toDate(),
        horaInicio: data['horaInicio'],
        horaFin: data['horaFin'],
        tema: data['tema'],
        estudiantesIds: List<String>.from(data['estudiantesIds'] ?? []),
        estado: data['estado'],
        createdAt: (data['createdAt'] as Timestamp).toDate(),
      );
    }).toList();
  }
}
