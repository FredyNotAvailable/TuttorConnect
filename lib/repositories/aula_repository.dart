import 'package:tutor_connect/models/aula.dart';

abstract class AulaRepository {
  Future<List<Aula>> obtenerTodasAulas();
  Future<Aula?> obtenerAulaPorId(String id);
}
