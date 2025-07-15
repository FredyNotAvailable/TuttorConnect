import 'package:flutter/material.dart';
import '../../models/usuario.dart';

class SolicitudesWidget extends StatelessWidget {
  final Usuario user;

  const SolicitudesWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    // Contenido simple con lista de solicitudes
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
                    title: const Text('Solicitud de Juan Pérez'),
                    subtitle: const Text('Materia: Física'),
                    trailing: ElevatedButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        // Acción para aceptar solicitud
                      },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    title: const Text('Solicitud de María López'),
                    subtitle: const Text('Materia: Matemáticas'),
                    trailing: ElevatedButton(
                      child: const Text('Aceptar'),
                      onPressed: () {
                        // Acción para aceptar solicitud
                      },
                    ),
                  ),
                ),
                // Más solicitudes según datos reales...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
