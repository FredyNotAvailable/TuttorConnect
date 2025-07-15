import 'package:flutter/material.dart';
import '../models/usuario.dart';

class TutoriasWidget extends StatelessWidget {
  final Usuario user;

  const TutoriasWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Aquí va el contenido real de las tutorías asignadas
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: ListTile(
                    title: const Text('Tutoría de Matemáticas'),
                    subtitle: const Text('Lunes 9:00 AM'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Acción al tocar esta tutoría (p. ej. ver detalles)
                    },
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Tutoría de Física'),
                    subtitle: const Text('Miércoles 11:00 AM'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // Acción al tocar esta tutoría
                    },
                  ),
                ),
                // Agrega más tarjetas según datos reales...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
