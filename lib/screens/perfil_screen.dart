import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/models/rol.dart';
import '../providers/usuario_provider.dart';
import '../providers/matricula_provider.dart';
import '../providers/carrera_provider.dart';
import '../providers/materia_provider.dart'; // Importa el provider de materias

class PerfilScreen extends StatefulWidget {
  static const routeName = '/perfil';

  const PerfilScreen({super.key});

  @override
  State<PerfilScreen> createState() => _PerfilScreenState();
}

class _PerfilScreenState extends State<PerfilScreen> {
  bool _carreraCargada = false;
  bool _materiasCargadas = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final usuarioProvider = context.read<UsuarioProvider>();
    final matriculaProvider = context.read<MatriculaProvider>();
    final carreraProvider = context.read<CarreraProvider>();
    final materiaProvider = context.read<MateriaProvider>();
    final usuario = usuarioProvider.usuario;

    // Solo si el usuario es estudiante, cargar matrícula, carrera y materias
    if (usuario != null && usuario.rol == RolUsuario.estudiante) {
      final matricula = matriculaProvider.matricula;

      if (!_carreraCargada && matricula != null) {
        carreraProvider.cargarCarrera(matricula.carreraId);
        _carreraCargada = true;
      }

      if (!_materiasCargadas && matricula != null) {
        materiaProvider.cargarMateriasPorIds(matricula.materiasInscritas);
        _materiasCargadas = true;
      }

      // Si no hay matrícula cargada, cargarla
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

    // Manejo carga usuario
    if (usuarioProvider.cargando) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // Manejo error usuario
    if (usuarioProvider.error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: Center(child: Text('Error: ${usuarioProvider.error}')),
      );
    }

    // Usuario no encontrado
    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: const Center(child: Text('No se encontró el usuario')),
      );
    }

    final rolTexto = usuario.rol.toString().split('.').last;

    return Scaffold(
      appBar: AppBar(title: const Text('Perfil de Usuario')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Datos Usuario
              const Text('Datos del Usuario',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Text('Nombre: ${usuario.nombre ?? 'No disponible'}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Correo: ${usuario.correo}',
                  style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Rol: $rolTexto', style: const TextStyle(fontSize: 18)),
              const SizedBox(height: 8),
              Text('Teléfono: ${usuario.telefono ?? 'No disponible'}',
                  style: const TextStyle(fontSize: 18)),

              const SizedBox(height: 24),

              // Mostrar datos académicos SOLO si es estudiante
              if (usuario.rol == RolUsuario.estudiante) ...[
                const Text('Datos Académicos - Matrícula',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                if (matricula != null) ...[
                  Text('Carrera: ${carrera?.nombre ?? 'Desconocida'}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  Text('Ciclo: ${matricula.ciclo}',
                      style: const TextStyle(fontSize: 18)),
                  const SizedBox(height: 8),
                  const Text('Materias Inscritas:',
                      style: TextStyle(fontSize: 18)),
                  const SizedBox(height: 4),
                  if (materiaProvider.cargando)
                    const CircularProgressIndicator()
                  else if (materiaProvider.materias.isEmpty)
                    const Text('No hay materias inscritas',
                        style:
                            TextStyle(fontSize: 16, fontStyle: FontStyle.italic))
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: materiaProvider.materias.length,
                      itemBuilder: (context, index) {
                        final materia = materiaProvider.materias[index];
                        return Text('- ${materia.nombre}',
                            style: const TextStyle(fontSize: 16));
                      },
                    ),
                  const SizedBox(height: 8),
                  Text('Matrícula Activa: ${matricula.matriculaActiva ? 'Sí' : 'No'}',
                      style: const TextStyle(fontSize: 18)),
                ] else
                  const Text('No hay matrícula activa',
                      style:
                          TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
