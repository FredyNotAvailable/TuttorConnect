import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/providers/materia_provider.dart';

import '../../models/tutoria.dart';
import '../../models/solicitud_tutoria.dart';
import '../../models/usuario.dart';
import '../../providers/auth_provider.dart';
import '../../providers/plan_docente_provider.dart';
import '../../providers/aula_provider.dart';
import '../../providers/matricula_provider.dart';
import '../../providers/usuario_provider.dart';
import '../../providers/tutoria_provider.dart';
import '../../providers/solicitud_tutoria_provider.dart';

class CrearTutoriaScreen extends StatefulWidget {
  static const routeName = '/crear_tutoria';

  const CrearTutoriaScreen({super.key});

  @override
  State<CrearTutoriaScreen> createState() => _CrearTutoriaScreenState();
}

class _CrearTutoriaScreenState extends State<CrearTutoriaScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _materiaId;
  String? _aulaId;
  DateTime? _fecha;
  TimeOfDay? _horaInicio;
  TimeOfDay? _horaFin;
  final _temaController = TextEditingController();

  List<String> _estudiantesIds = [];
  List<Usuario> _estudiantes = [];

  bool _cargandoEstudiantes = false;

  @override
  void initState() {
    super.initState();
    _cargarMateriasYAulas();
  }

  Future<void> _cargarMateriasYAulas() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final planDocenteProvider = Provider.of<PlanDocenteProvider>(context, listen: false);
    final aulaProvider = Provider.of<AulaProvider>(context, listen: false);
    final materiaProvider = Provider.of<MateriaProvider>(context, listen: false); // <--- Aquí

    final usuarioActual = authProvider.user;
    if (usuarioActual == null) return;

    await planDocenteProvider.cargarPlanPorDocenteId(usuarioActual.id);
    await aulaProvider.cargarAulas();
    await materiaProvider.cargarMaterias(); // Ahora ya funciona porque está definido

    setState(() {}); // Refrescar UI
  }


  Future<void> _selectFecha(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fecha ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null) setState(() => _fecha = picked);
  }

  Future<void> _selectHoraInicio(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaInicio ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaInicio = picked);
  }

  Future<void> _selectHoraFin(BuildContext context) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _horaFin ?? TimeOfDay.now(),
    );
    if (picked != null) setState(() => _horaFin = picked);
  }

Future<void> _cargarEstudiantesPorMateria(String materiaId) async {
  setState(() {
    _estudiantes = [];
    _estudiantesIds = [];
    _cargandoEstudiantes = true;
  });

  final planDocenteProvider = Provider.of<PlanDocenteProvider>(context, listen: false);
  final usuarioProvider = Provider.of<UsuarioProvider>(context, listen: false);
  final matriculaProvider = Provider.of<MatriculaProvider>(context, listen: false);

  final plan = planDocenteProvider.plan;

  if (plan == null) {
    print('[DEBUG] No hay plan docente cargado');
    setState(() => _cargandoEstudiantes = false);
    return;
  }

  // Buscar ciclo para la materia
  int? ciclo;
  plan.materiasPorCiclo.forEach((key, materias) {
    if (materias.contains(materiaId)) {
      ciclo = int.tryParse(key);
    }
  });

  if (ciclo == null) {
    print('[DEBUG] No se encontró ciclo para la materia $materiaId');
    setState(() => _cargandoEstudiantes = false);
    return;
  }

  print('[DEBUG] Ciclo encontrado para materia $materiaId: $ciclo');

  // Ahora carga los estudiantes inscritos en la materia y ciclo
  await matriculaProvider.cargarEstudiantesPorMateriaYCiclo(materiaId, ciclo??0);

  final estudiantesIds = matriculaProvider.estudiantesIds;

  print('[DEBUG] estudiantesIds obtenidos: $estudiantesIds');

  if (estudiantesIds.isEmpty) {
    setState(() {
      _estudiantes = [];
      _cargandoEstudiantes = false;
    });
    return;
  }

  // Carga datos completos de los usuarios
  final usuarios = await usuarioProvider.cargarUsuariosPorIds(estudiantesIds);

  print('[DEBUG] Estudiantes cargados con datos completos: $usuarios');

  setState(() {
    _estudiantes = usuarios;
    _estudiantesIds = estudiantesIds;
    _cargandoEstudiantes = false;
  });
}


  Future<void> _crearTutoria() async {
    if (_formKey.currentState?.validate() != true) return;

    if (_fecha == null || _horaInicio == null || _horaFin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona fecha y hora')),
      );
      return;
    }

    if (_horaFin!.hour < _horaInicio!.hour ||
        (_horaFin!.hour == _horaInicio!.hour && _horaFin!.minute <= _horaInicio!.minute)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La hora fin debe ser después de la hora inicio')),
      );
      return;
    }

    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final usuarioActual = authProvider.user;

    if (usuarioActual == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No hay usuario autenticado')),
      );
      return;
    }

    final tutoriaProvider = Provider.of<TutoriaProvider>(context, listen: false);
    final solicitudProvider = Provider.of<SolicitudTutoriaProvider>(context, listen: false);
    final matriculaProvider = Provider.of<MatriculaProvider>(context, listen: false);

    final nuevaTutoria = Tutoria(
      id: '',
      docenteId: usuarioActual.id,
      materiaId: _materiaId!,
      aulaId: _aulaId!,
      fecha: _fecha!,
      horaInicio: _horaInicio!.format(context),
      horaFin: _horaFin!.format(context),
      tema: _temaController.text.trim(),
      estudiantesIds: [], // Vacío, los estudiantes aceptan la solicitud
      estado: 'activa',
      createdAt: DateTime.now()
    );

    try {
      final tutoriaCreada = await tutoriaProvider.crearTutoria(nuevaTutoria);

      // Crea solicitudes para estudiantes que corresponden a la materia y ciclo
      final estudiantesIds = matriculaProvider.estudiantesIds;

      final solicitudes = estudiantesIds.map((estudianteId) {
        final idSolicitud = '${tutoriaCreada.id}_$estudianteId';
        return SolicitudTutoria(
          id: idSolicitud,
          tutoriaId: tutoriaCreada.id,
          estudianteId: estudianteId,
          estado: 'pendiente',
          fechaRespuesta: null,
          createdAt: DateTime.now(),  // <-- aquí agregas la fecha de creación
        );
      }).toList();

      await solicitudProvider.crearSolicitudes(solicitudes);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tutoría y solicitudes creadas correctamente')),
      );

      Navigator.pop(context, tutoriaCreada);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear tutoría: $e')),
      );
    }
  }

  @override
  void dispose() {
    _temaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final planDocenteProvider = Provider.of<PlanDocenteProvider>(context);
    final aulaProvider = Provider.of<AulaProvider>(context);
    final materiaProvider = Provider.of<MateriaProvider>(context);

    final materiaIdsPlan = (planDocenteProvider.plan?.materiasPorCiclo.values
            .expand((materias) => materias)
            .toSet()
            .toList() ?? []);

    final materiasFiltradas = materiaProvider.materias
        .where((mat) => materiaIdsPlan.contains(mat.id))
        .toList();

    final materiasItems = materiasFiltradas.map((mat) {
      return DropdownMenuItem<String>(
        value: mat.id,
        child: Text(mat.nombre ?? 'Sin nombre'),
      );
    }).toList();


    final aulasItems = aulaProvider.aulas
        .map((aula) => DropdownMenuItem<String>(
              value: aula.id,
              child: Text(aula.nombre),
            ))
        .toList();

      if (planDocenteProvider.cargando || aulaProvider.isLoading || materiaProvider.cargando) {
        return const Center(child: CircularProgressIndicator());
      }

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Tutoría')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              if (planDocenteProvider.cargando || aulaProvider.isLoading)
                const Center(child: CircularProgressIndicator())
              else ...[
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Materia'),
                  items: materiasItems,
                  value: _materiaId,
                  onChanged: (value) async {
                    setState(() {
                      _materiaId = value;
                      _estudiantesIds = [];
                      _estudiantes = [];
                    });
                    if (value != null) {
                      await _cargarEstudiantesPorMateria(value);
                    }
                  },
                  validator: (value) => value == null ? 'Selecciona una materia' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Aula'),
                  items: aulasItems,
                  value: _aulaId,
                  onChanged: (value) => setState(() => _aulaId = value),
                  validator: (value) => value == null ? 'Selecciona un aula' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _temaController,
                  decoration: const InputDecoration(labelText: 'Tema'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Ingrese un tema' : null,
                ),
                const SizedBox(height: 16),
                if (_cargandoEstudiantes)
                  const Center(child: CircularProgressIndicator())
                else if (_estudiantes.isNotEmpty) ...[
                  const Text(
                    'Estudiantes a quienes se enviará la solicitud:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  ..._estudiantes.map((est) => ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(est.nombre ?? 'Nombre no disponible'),
                  )),
                  const SizedBox(height: 16),
                ] else if (_materiaId != null) ...[
                  const SizedBox(height: 16),
                  const Text(
                    'No hay estudiantes inscritos en esta materia.',
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Expanded(
                      child: Text(_fecha == null
                          ? 'Seleccione una fecha'
                          : 'Fecha: ${_fecha!.day}/${_fecha!.month}/${_fecha!.year}'),
                    ),
                    TextButton(
                      onPressed: () => _selectFecha(context),
                      child: const Text('Elegir fecha'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(_horaInicio == null
                          ? 'Hora inicio'
                          : 'Inicio: ${_horaInicio!.format(context)}'),
                    ),
                    TextButton(
                      onPressed: () => _selectHoraInicio(context),
                      child: const Text('Elegir hora'),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(_horaFin == null
                          ? 'Hora fin'
                          : 'Fin: ${_horaFin!.format(context)}'),
                    ),
                    TextButton(
                      onPressed: () => _selectHoraFin(context),
                      child: const Text('Elegir hora'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _crearTutoria,
                  child: const Text('Crear tutoría'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
