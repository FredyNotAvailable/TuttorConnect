import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/tutoria.dart';
import 'package:tutor_connect/repositories/tutoria_repository.dart';

class TutoriaService {
  final TutoriaRepository _repository;

  TutoriaService(this._repository);

  Future<List<Tutoria>> obtenerTutoriasPorDocente(String docenteId) {
    return _repository.obtenerTutoriasPorDocente(docenteId);
  }

  Future<List<Tutoria>> obtenerTutoriasPorEstudiante(String estudianteId) {
    return _repository.obtenerTutoriasPorEstudiante(estudianteId);
  }

  Future<Tutoria?> obtenerTutoriaPorId(String id) {
    return _repository.obtenerTutoriaPorId(id);
  }

  Future<List<Tutoria>> obtenerTutoriasActivas() {
    return _repository.obtenerTutoriasActivas();
  }

  Future<void> crearTutoria(Tutoria tutoria) {
    return _repository.crearTutoria(tutoria);
  }

  /// Crea la tutoría y devuelve una instancia con el ID asignado por Firestore.
  Future<Tutoria> crearTutoriaYRetornar(Tutoria tutoria) async {
    final docRef = await (_repository as dynamic).crearTutoriaYRetornarDocumento(tutoria);
    return Tutoria(
      id: docRef.id,
      docenteId: tutoria.docenteId,
      materiaId: tutoria.materiaId,
      aulaId: tutoria.aulaId,
      fecha: tutoria.fecha,
      horaInicio: tutoria.horaInicio,
      horaFin: tutoria.horaFin,
      tema: tutoria.tema,
      estudiantesIds: tutoria.estudiantesIds,
      estado: tutoria.estado,
      createdAt: tutoria.createdAt,
    );
  }

  Future<void> actualizarTutoria(Tutoria tutoria) {
    return _repository.actualizarTutoria(tutoria);
  }

  Future<void> cancelarTutoria(String id) {
    return _repository.cancelarTutoria(id);
  }

  Future<List<Tutoria>> obtenerTutoriasPorMateriaYDocente(String materiaId, String docenteId) {
    return _repository.obtenerTutoriasPorMateriaYDocente(materiaId, docenteId);
  }

  Future<bool> validarDisponibilidadAula(
      String aulaId, DateTime fecha, String horaInicio, String horaFin) {
    return _repository.validarDisponibilidadAula(aulaId, fecha, horaInicio, horaFin);
  }

  Future<List<Tutoria>> obtenerTutoriasPorFecha(DateTime fecha) {
    return _repository.obtenerTutoriasPorFecha(fecha);
  }

  Future<List<Tutoria>> buscarTutoriasPorTema(String tema) {
    return _repository.buscarTutoriasPorTema(tema);
  }

  Future<List<Tutoria>> obtenerTutoriasPorIds(List<String> ids) {
    return _repository.obtenerTutoriasPorIds(ids);
  }

  /// Agrega un estudiante a la lista de estudiantes confirmados de una tutoría.
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId) {
    return _repository.agregarEstudianteATutoria(tutoriaId, estudianteId);
  }
}
