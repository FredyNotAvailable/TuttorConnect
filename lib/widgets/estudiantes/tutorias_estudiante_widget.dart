import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/usuario.dart';
import '../../providers/tutoria_provider.dart';
import '../../app_routes.dart';

class TutoriasEstudianteWidget extends StatefulWidget {
  final Usuario user;

  const TutoriasEstudianteWidget({super.key, required this.user});

  @override
  State<TutoriasEstudianteWidget> createState() => _TutoriasEstudianteWidgetState();
}

class _TutoriasEstudianteWidgetState extends State<TutoriasEstudianteWidget> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<TutoriaProvider>(context, listen: false);
      provider.cargarTutoriasPorEstudiante(widget.user.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TutoriaProvider>(context);
    final tutorias = provider.tutorias;
    final isLoading = provider.isLoading;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Mis tutorías',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : tutorias.isEmpty
                    ? const Center(child: Text('No estás inscrito en ninguna tutoría.'))
                    : ListView.builder(
                        itemCount: tutorias.length,
                        itemBuilder: (context, index) {
                          final tutoria = tutorias[index];
                          return Card(
                            child: ListTile(
                              title: Text('Tema: ${tutoria.tema}'),
                              subtitle: Text(
                                '${tutoria.fecha.day}/${tutoria.fecha.month}/${tutoria.fecha.year} '
                                '– ${tutoria.horaInicio} - ${tutoria.horaFin}',
                              ),
                              trailing: const Icon(Icons.chevron_right),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  AppRoutes.detalleTutoria,
                                  arguments: tutoria,
                                );
                              },
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
