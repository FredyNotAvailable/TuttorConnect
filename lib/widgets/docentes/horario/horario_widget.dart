import 'package:flutter/material.dart';
import 'package:tutor_connect/models/rol.dart';
import '../../../models/usuario.dart';
import 'horario_docente_widget.dart';
import '../../estudiantes/horario/horario_estudiante_widget.dart';

class HorarioWidget extends StatelessWidget {
  final Usuario user;

  const HorarioWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    Widget contenido;

    switch (user.rol) {
      case RolUsuario.docente:
        contenido = HorarioDocenteWidget(
          docenteId: user.id,
          onAgregarHorario: () {},
          onEditarHorario: (horario) {},
          onEliminarHorario: (id) {},
        );
        break;
      case RolUsuario.estudiante:
        contenido = HorarioEstudianteWidget();
        break;
    }

    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(child: contenido),
    );
  }
}
