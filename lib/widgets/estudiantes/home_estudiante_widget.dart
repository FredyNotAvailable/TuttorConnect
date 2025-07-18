import 'package:flutter/material.dart';
import 'package:tutor_connect/widgets/estudiantes/tutorias_estudiante_widget.dart';
import '../../models/usuario.dart';
import 'solicitudes_widget.dart';  // Importa el widget de notificaciones

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
      TutoriasEstudianteWidget(user: widget.user),        // Pantalla de tutorías
      SolicitudesWidget(user: widget.user),  // Pantalla de notificaciones
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'Tutorías'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Solicitudes'),
        ],
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
    );
  }
}
