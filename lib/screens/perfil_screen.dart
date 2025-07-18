import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/models/rol.dart';
import '../providers/usuario_provider.dart';
import '../providers/matricula_provider.dart';
import '../providers/carrera_provider.dart';
import '../providers/materia_provider.dart';
import '../providers/malla_curricular_provider.dart';

class PerfilScreen extends StatefulWidget {
  static const routeName = '/perfil';

  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _datosCargados = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final usuarioProvider = context.read<UsuarioProvider>();
    final matriculaProvider = context.read<MatriculaProvider>();
    final carreraProvider = context.read<CarreraProvider>();
    final mallaProvider = context.read<MallaCurricularProvider>();
    final materiaProvider = context.read<MateriaProvider>();

    final usuario = usuarioProvider.usuario;
    final matricula = matriculaProvider.matricula;

    if (usuario != null && usuario.rol == RolUsuario.estudiante) {
      if (!_datosCargados && matricula != null) {
        carreraProvider.cargarCarrera(matricula.carreraId);

        mallaProvider.cargarMalla(matricula.carreraId).then((_) {
          final cicloStr = matricula.ciclo.toString();
          final materiasIds = mallaProvider.malla?.materiasPorCiclo[cicloStr] ?? [];
          materiaProvider.cargarMateriasPorIds(materiasIds);
        });

        _datosCargados = true;
      }

      if (!matriculaProvider.cargando && matricula == null) {
        matriculaProvider.cargarMatricula(usuario.id);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuarioProvider = context.watch<UsuarioProvider>();
    final matriculaProvider = context.watch<MatriculaProvider>();
    final carreraProvider = context.watch<CarreraProvider>();
    final materiaProvider = context.watch<MateriaProvider>();

    final usuario = usuarioProvider.usuario;
    final matricula = matriculaProvider.matricula;
    final carrera = carreraProvider.carrera;

    if (usuarioProvider.cargando) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (usuarioProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: Center(child: Text('Error: ${usuarioProvider.error}')),
      );
    }

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: const Center(child: Text('No se encontró el usuario')),
      );
    }

    final rolTexto = usuario.rol.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Información Personal',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(usuario.nombre ?? 'No disponible'),
                    subtitle: const Text('Nombre completo'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: Text(usuario.correo),
                    subtitle: const Text('Correo electrónico'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.shield),
                    title: Text(rolTexto.toUpperCase()),
                    subtitle: const Text('Rol asignado'),
                  ),
                  if (usuario.telefono != null) ...[
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(usuario.telefono!),
                      subtitle: const Text('Teléfono'),
                    ),
                  ]
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (usuario.rol == RolUsuario.estudiante) ...[
            const Text(
              'Información Académica',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                child: Column(
                  children: [
                    if (matricula != null) ...[
                      ListTile(
                        leading: const Icon(Icons.school),
                        title: Text(carrera?.nombre ?? 'Desconocida'),
                        subtitle: const Text('Carrera'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.timeline),
                        title: Text('Ciclo ${matricula.ciclo}'),
                        subtitle: const Text('Nivel actual'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.check_circle_outline),
                        title: Text(matricula.matriculaActiva ? 'Sí' : 'No'),
                        subtitle: const Text('Matrícula activa'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.book),
                        title: const Text('Materias Inscritas'),
                        subtitle: materiaProvider.cargando
                            ? const Padding(
                                padding: EdgeInsets.only(top: 8.0),
                                child: CircularProgressIndicator(),
                              )
                            : materiaProvider.materias.isEmpty
                                ? const Padding(
                                    padding: EdgeInsets.only(top: 4),
                                    child: Text(
                                      'No hay materias inscritas',
                                      style: TextStyle(fontStyle: FontStyle.italic),
                                    ),
                                  )
                                : Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: materiaProvider.materias
                                        .map((m) => Padding(
                                              padding: const EdgeInsets.only(top: 4),
                                              child: Text('• ${m.nombre}',
                                                  style: const TextStyle(fontSize: 16)),
                                            ))
                                        .toList(),
                                  ),
                      ),
                    ] else
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(
                          'No hay matrícula activa',
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
