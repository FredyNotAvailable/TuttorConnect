import 'package:flutter/material.dart';
import '../../models/usuario.dart';

class VerDocentesWidget extends StatelessWidget {
  final Usuario user;

  const VerDocentesWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ver Docentes Disponibles', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${user.nombre}'),
          // Aquí va lista o grid de docentes
        ],
      ),
    );
  }
}
