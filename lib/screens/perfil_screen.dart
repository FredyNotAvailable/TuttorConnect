import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/rol.dart';
import '../providers/auth_provider.dart';

class PerfilScreen extends StatelessWidget {
  static const routeName = '/perfil';

  const PerfilScreen({Key? key}) : super(key: key);

  String _formatFecha(Timestamp? timestamp) {
    if (timestamp == null) return 'No disponible';
    final date = timestamp.toDate();
    return DateFormat.yMMMMd().format(date);
  }

  String _rolTexto(RolUsuario rol) {
    switch (rol) {
      case RolUsuario.docente:
        return 'Docente';
      case RolUsuario.estudiante:
        return 'Estudiante';
      default:
        return 'Desconocido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final usuario = context.watch<AuthProvider>().user;

    if (usuario == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Perfil de Usuario')),
        body: const Center(child: Text('Usuario no autenticado')),
      );
    }

    final estiloTitulo = TextStyle(
      fontWeight: FontWeight.w600,
      fontSize: 14,
      color: Colors.grey[600],
      letterSpacing: 1.2,
    );

    final estiloValor = const TextStyle(
      fontSize: 18,
      color: Colors.black87,
      fontWeight: FontWeight.w500,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 0,
      ),
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Card(
          elevation: 6,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 48,
                  backgroundColor: Colors.indigo.shade100,
                  child: Text(
                    (usuario.nombre != null && usuario.nombre!.isNotEmpty)
                        ? usuario.nombre![0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 48, color: Colors.indigo),
                  ),
                ),
                const SizedBox(height: 24),
                _buildDato('Nombre', usuario.nombre ?? 'No registrado', estiloTitulo, estiloValor),
                _buildDato('Correo', usuario.correo, estiloTitulo, estiloValor),
                _buildDato('Teléfono', usuario.telefono ?? 'No registrado', estiloTitulo, estiloValor),
                _buildDato('Rol', _rolTexto(usuario.rol), estiloTitulo, estiloValor),
                _buildDato('Creado el', _formatFecha(usuario.createdAt), estiloTitulo, estiloValor),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDato(String titulo, String valor, TextStyle estiloTitulo, TextStyle estiloValor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(titulo.toUpperCase(), style: estiloTitulo),
          const SizedBox(height: 4),
          Text(valor, style: estiloValor),
          const Divider(height: 18, thickness: 1.1),
        ],
      ),
    );
  }
}
