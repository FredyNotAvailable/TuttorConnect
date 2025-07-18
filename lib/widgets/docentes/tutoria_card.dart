import 'package:flutter/material.dart';

class TutoriaCard extends StatelessWidget {
  final String titulo;
  final String subtitulo;
  final VoidCallback onTap;

  const TutoriaCard({
    super.key,
    required this.titulo,
    required this.subtitulo,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(titulo),
        subtitle: Text(subtitulo),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
