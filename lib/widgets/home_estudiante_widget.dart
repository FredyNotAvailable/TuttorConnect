import 'package:flutter/material.dart';
import '../models/usuario.dart';

class HomeEstudianteWidget extends StatefulWidget {
  final Usuario user;

  const HomeEstudianteWidget({Key? key, required this.user}) : super(key: key);

  @override
  State<HomeEstudianteWidget> createState() => _HomeEstudianteState();
}

class _HomeEstudianteState extends State<HomeEstudianteWidget> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _solicitarTutoriaPage(),
      _historialTutoriasPage(),
      _verDocentesPage(),
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

  Widget _solicitarTutoriaPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Solicitar Tutoría', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${widget.user.nombre}'),
          // Aquí va formulario o contenido para solicitar
        ],
      ),
    );
  }

  Widget _historialTutoriasPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Historial de Tutorías', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${widget.user.nombre}'),
          // Aquí va historial real
        ],
      ),
    );
  }

  Widget _verDocentesPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Ver Docentes Disponibles', style: TextStyle(fontSize: 24)),
          Text('Estudiante: ${widget.user.nombre}'),
          // Aquí va lista o grid de docentes
        ],
      ),
    );
  }
}
