import 'package:flutter/material.dart';
import '../models/usuario.dart';

class HorarioWidget extends StatelessWidget {
  final Usuario user;

  const HorarioWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Aquí solo un placeholder básico para el horario
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Center(
              child: Text(
                'Aquí va el calendario o la grilla de horarios',
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
