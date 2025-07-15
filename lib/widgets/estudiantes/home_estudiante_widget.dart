import 'package:flutter/material.dart';
import '../../models/usuario.dart';
import 'solicitar_tutoria_widget.dart';
import 'historial_tutorias_widget.dart';
import 'ver_docentes_widget.dart';

class HomeEstudianteWidget extends StatefulWidget {
  final Usuario user;

  const HomeEstudianteWidget({super.key, required this.user});

  @override
  State<HomeEstudianteWidget> createState() => _HomeEstudianteWidgetState();
}

class _HomeEstudianteWidgetState extends State<HomeEstudianteWidget> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      SolicitarTutoriaWidget(user: widget.user),
      HistorialTutoriasWidget(user: widget.user),
      VerDocentesWidget(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Solicitar'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Docentes'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
