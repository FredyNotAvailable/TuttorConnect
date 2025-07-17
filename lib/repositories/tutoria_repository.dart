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
}
