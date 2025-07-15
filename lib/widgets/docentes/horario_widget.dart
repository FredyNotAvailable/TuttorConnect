import 'package:flutter/material.dart';
import '../../models/usuario.dart';

class HorarioWidget extends StatelessWidget {
  final Usuario user;

  const HorarioWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: user.rol.name == 'docente'
          ? _buildHorarioDocente()
          : _buildHorarioEstudiante(),
    );
  }

  /// Vista para docentes
  Widget _buildHorarioDocente() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Disponibilidad del Docente',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text('- Lunes: 14:00 - 16:00'),
        Text('- Miércoles: 10:00 - 12:00'),
        Text('- Viernes: 08:00 - 10:00'),
      ],
    );
  }

  /// Vista para estudiantes
  Widget _buildHorarioEstudiante() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Tutorías Reservadas',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Text('- Lunes 15/07: Tutoría de Cálculo - 14:00'),
        Text('- Jueves 18/07: Tutoría de Física - 10:00'),
      ],
    );
  }
}
