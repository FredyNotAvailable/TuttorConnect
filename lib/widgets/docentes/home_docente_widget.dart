import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import 'tutorias_widget.dart';
import 'solicitudes_widget.dart';
import 'horario_widget.dart';

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
      TutoriasWidget(user: widget.user),
      SolicitudesWidget(user: widget.user),
      HorarioWidget(user: widget.user),
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
          BottomNavigationBarItem(icon: Icon(Icons.inbox), label: 'Solicitudes'),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Horario'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
