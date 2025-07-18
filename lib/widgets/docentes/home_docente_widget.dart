import 'package:flutter/material.dart';
import 'package:tutor_connect/models/usuario.dart';

import 'tutorias_docente_widget.dart';
import 'configuracion_widget.dart'; // importa el widget

class HomeDocenteWidget extends StatefulWidget {
  final Usuario user;
  const HomeDocenteWidget({super.key, required this.user});

  @override
  State<HomeDocenteWidget> createState() => _HomeDocenteState();
}

class _HomeDocenteState extends State<HomeDocenteWidget> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      TutoriasDocenteWidget(user: widget.user),
      const ConfiguracionWidget(),  // aquí
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Tutorías'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Configuración'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
