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
    // Aquí podrías añadir validaciones o reglas antes de crear
    return _repository.crearTutoria(tutoria);
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
}
