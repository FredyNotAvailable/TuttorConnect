import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/horario_disponible.dart';
import '../../../models/materia.dart';
import '../../../models/plan_docente.dart';
import '../../../providers/horario_disponible_provider.dart';
import '../../../providers/materia_provider.dart';
import '../../../providers/carrera_provider.dart';
import '../../../providers/plan_docente_provider.dart';

class HorarioDocenteWidget extends StatefulWidget {
  final String docenteId;

  final void Function() onAgregarHorario;
  final void Function(HorarioDisponible) onEditarHorario;
  final void Function(String) onEliminarHorario;

  const HorarioDocenteWidget({
    super.key,
    required this.docenteId,
    required this.onAgregarHorario,
    required this.onEditarHorario,
    required this.onEliminarHorario,
  });

  @override
  State<HorarioDocenteWidget> createState() => _HorarioDocenteWidgetState();
}

class _HorarioDocenteWidgetState extends State<HorarioDocenteWidget> {
  bool _cargadoHorarios = false;
  bool _cargadoMaterias = false;
  bool _cargadoCarrera = false;
  bool _cargadoPlanDocente = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final horarioProvider = Provider.of<HorarioDisponibleProvider>(context, listen: false);
    final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);
    final carreraProvider = Provider.of<CarreraProvider>(context, listen: false);
    final planDocenteProvider = Provider.of<PlanDocenteProvider>(context, listen: false);

    if (!_cargadoPlanDocente) {
      _cargadoPlanDocente = true; // <- setear antes para evitar llamadas repetidas
      print('Iniciando carga del plan docente para docenteId=${widget.docenteId}');
      planDocenteProvider.cargarPlanPorDocenteId(widget.docenteId).then((_) async {
        final planDocente = planDocenteProvider.plan;
        print('Plan docente cargado: $planDocente');

        if (!_cargadoHorarios) {
          print('Cargando horarios para docenteId=${widget.docenteId}');
          await horarioProvider.cargarHorariosPorDocente(widget.docenteId);
          print('Horarios cargados: ${horarioProvider.horarios.length}');
          _cargadoHorarios = true;
        }

        final horarios = horarioProvider.horarios;
        final materiaIds = horarios.map((h) => h.materiaId).toSet().toList();
        print('IDs de materias encontrados en horarios: $materiaIds');

        if (!_cargadoMaterias) {
          print('Cargando materias con IDs: $materiaIds');
          await materiaProvider.cargarMateriasPorIds(materiaIds);
          print('Materias cargadas: ${materiaProvider.materias.length}');
          _cargadoMaterias = true;
        }

        if (!_cargadoCarrera && planDocente != null) {
          print('Cargando carrera con id: ${planDocente.carreraId}');
          await carreraProvider.cargarCarrera(planDocente.carreraId);
          print('Carrera cargada: ${carreraProvider.carrera}');
          _cargadoCarrera = true;
        }

        if (mounted) {
          setState(() {
            print('Carga completa, setState llamado');
          });
        }
      }).catchError((error) {
        print('Error en la carga del plan docente o datos relacionados: $error');
      });
    }
  }


  /// Retorna el ciclo (String) en el que está la materia según el plan docente.
  String obtenerCicloDeMateria(PlanDocente? plan, String materiaId) {

    if (plan == null) {
      print('PlanDocente es null, no puedo obtener ciclo');
      return 'Desconocido';
    }
    for (final entry in plan.materiasPorCiclo.entries) {
      print('Ciclo: ${entry.key}, Materias: ${entry.value}');
      if (entry.value.contains(materiaId)) {
        print('Materia $materiaId encontrada en ciclo ${entry.key}');
        print('Buscando materiaId: $materiaId — Plan contiene: ${plan.materiasPorCiclo}');

        return entry.key;
      }
    }
    return 'Desconocido';
  }

  @override
  Widget build(BuildContext context) {
    final horarioProvider = Provider.of<HorarioDisponibleProvider>(context);
    final materiaProvider = Provider.of<MateriaProvider>(context);
    final carreraProvider = Provider.of<CarreraProvider>(context);
    final planDocenteProvider = Provider.of<PlanDocenteProvider>(context);

    if (horarioProvider.cargando ||
        materiaProvider.cargando ||
        carreraProvider.cargando ||
        planDocenteProvider.cargando) {
      print('Esperando carga, mostrando CircularProgressIndicator');
      return const Center(child: CircularProgressIndicator());
    }

    if (horarioProvider.error != null) {
      print('Error al cargar horarios: ${horarioProvider.error}');
      return Center(child: Text('Error al cargar horarios: ${horarioProvider.error}'));
    }

    if (materiaProvider.error != null) {
      print('Error al cargar materias: ${materiaProvider.error}');
      return Center(child: Text('Error al cargar materias: ${materiaProvider.error}'));
    }

    if (carreraProvider.error != null) {
      print('Error al cargar carrera: ${carreraProvider.error}');
      return Center(child: Text('Error al cargar carrera: ${carreraProvider.error}'));
    }

    if (planDocenteProvider.error != null) {
      print('Error al cargar plan docente: ${planDocenteProvider.error}');
      return Center(child: Text('Error al cargar plan docente: ${planDocenteProvider.error}'));
    }

    final horarios = horarioProvider.horarios;
    final carrera = carreraProvider.carrera;
    final planDocente = planDocenteProvider.plan;

    if (horarios.isEmpty) {
      print('No hay horarios disponibles para el docente.');
      return const Text('No hay horarios disponibles para el docente.');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Horario del Docente',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        if (carrera != null)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text('Carrera: ${carrera.nombre}', style: const TextStyle(fontSize: 16)),
          ),
        ElevatedButton(
          onPressed: widget.onAgregarHorario,
          child: const Text('Agregar horario'),
        ),
        const SizedBox(height: 8),
        ...horarios.map((horario) {
          final materia = materiaProvider.materias.firstWhere(
            (m) => m.id == horario.materiaId,
            orElse: () => Materia(
              id: '',
              nombre: 'Materia desconocida',
            ),
          );

          final nombreMateria = materia.nombre;
          final ciclo = obtenerCicloDeMateria(planDocente, materia.id);

          return Card(
            margin: const EdgeInsets.symmetric(vertical: 4),
            child: ListTile(
              title: Text(nombreMateria),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (carrera != null)
                    Text('Carrera: ${carrera.nombre}'),
                    Text('Ciclo: $ciclo'),
                    Text('Día: ${horario.diaSemana}'),
                    Text('Horario: ${horario.horaInicio} - ${horario.horaFin}'),
                    Text('Disponible: ${horario.disponible ? "Sí" : "No"}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => widget.onEditarHorario(horario),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => widget.onEliminarHorario(horario.id),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
}
