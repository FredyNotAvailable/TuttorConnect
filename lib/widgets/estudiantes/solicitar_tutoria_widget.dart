import 'package:flutter/material.dart';
import '../../models/usuario.dart';

class SolicitarTutoriaWidget extends StatelessWidget {
  final Usuario user;

  const SolicitarTutoriaWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Solicitar Tutoría', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${user.nombre}'),
          // Aquí va formulario o contenido para solicitar tutoría
        ],
      ),
    );
  }
}
