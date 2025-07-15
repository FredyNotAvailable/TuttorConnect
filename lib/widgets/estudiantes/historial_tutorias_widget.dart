import 'package:flutter/material.dart';
import '../../models/usuario.dart';

class HistorialTutoriasWidget extends StatelessWidget {
  final Usuario user;

  const HistorialTutoriasWidget({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Historial de Tutorías', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${user.nombre}'),
          // Aquí va el historial real
        ],
      ),
    );
  }
}
