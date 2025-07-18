import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/usuario.dart';
import '../../providers/tutoria_provider.dart';
import '../../providers/materia_provider.dart';
import '../../models/materia.dart';
import '../../app_routes.dart';

class TutoriasEstudianteWidget extends StatefulWidget {
  final Usuario user;

  const TutoriasEstudianteWidget({super.key, required this.user});

  @override
  State<TutoriasEstudianteWidget> createState() => _TutoriasEstudianteWidgetState();
}

class _TutoriasEstudianteWidgetState extends State<TutoriasEstudianteWidget> {
  String? materiaSeleccionada;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final tutoriaProvider = Provider.of<TutoriaProvider>(context, listen: false);
      final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);

      tutoriaProvider.cargarTutoriasPorEstudiante(widget.user.id);
      if (materiaProvider.materias.isEmpty) {
        materiaProvider.cargarMaterias();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final tutoriaProvider = Provider.of<TutoriaProvider>(context);
    final materiaProvider = Provider.of<MateriaProvider>(context);

    final isLoading = tutoriaProvider.isLoading || materiaProvider.cargando;
    final materias = materiaProvider.materias;
    final todasLasTutorias = tutoriaProvider.tutorias;

    // Filtrar tutorías por materia seleccionada
    final tutorias = materiaSeleccionada == null
        ? todasLasTutorias
        : todasLasTutorias
            .where((t) => t.materiaId == materiaSeleccionada)
            .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 12),
          DropdownButton<String>(
            isExpanded: true,
            hint: const Text('Filtrar por materia'),
            value: materiaSeleccionada,
            items: [
              const DropdownMenuItem<String>(
                value: null,
                child: Text('Todas las materias'),
              ),
              ...materias.map((m) => DropdownMenuItem(
                    value: m.id,
                    child: Text(m.nombre),
                  ))
            ],
            onChanged: (value) {
              setState(() {
                materiaSeleccionada = value;
              });
            },
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
                          final materiaNombre = materiaProvider.materias
                                  .firstWhere(
                                    (m) => m.id == tutoria.materiaId,
                                    orElse: () => Materia(id: '', nombre: 'Materia desconocida'),
                                  )
                                  .nombre;

                          return Card(
                            child: ListTile(
                              title: Text('Materia: $materiaNombre'),
                              subtitle: Text(
                                'Tema: ${tutoria.tema}\n'
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
