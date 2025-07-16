import 'package:flutter/material.dart';

class HorarioEstudianteWidget extends StatelessWidget {
  const HorarioEstudianteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text('Horario del Estudiante',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 8),
        Text('Aquí se mostrarán los horarios del estudiante.'),
      ],
    );
  }
}
