import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tutor_connect/models/tutoria.dart';

abstract class TutoriaRepository {
  Future<List<Tutoria>> obtenerTutoriasPorDocente(String docenteId);
  Future<List<Tutoria>> obtenerTutoriasPorEstudiante(String estudianteId);
  Future<Tutoria?> obtenerTutoriaPorId(String id);
  Future<List<Tutoria>> obtenerTutoriasActivas();

  Future<void> crearTutoria(Tutoria tutoria);
  Future<void> actualizarTutoria(Tutoria tutoria);
  Future<void> cancelarTutoria(String id);

  Future<List<Tutoria>> obtenerTutoriasPorMateriaYDocente(String materiaId, String docenteId);
  Future<bool> validarDisponibilidadAula(String aulaId, DateTime fecha, String horaInicio, String horaFin);

  Future<List<Tutoria>> obtenerTutoriasPorFecha(DateTime fecha);
  Future<List<Tutoria>> buscarTutoriasPorTema(String tema);

  /// Nuevo método que crea la tutoría y retorna el DocumentReference generado en Firestore
  Future<DocumentReference> crearTutoriaYRetornarDocumento(Tutoria tutoria);
  Future<List<Tutoria>> obtenerTutoriasPorIds(List<String> ids);
  Future<void> agregarEstudianteATutoria(String tutoriaId, String estudianteId);
}
