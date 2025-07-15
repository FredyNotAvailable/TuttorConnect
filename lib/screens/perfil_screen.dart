import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  static const routeName = '/perfil';

  const PerfilScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Usuario'),
      ),
      body: const Center(
        child: Text(
          'Perfil',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
