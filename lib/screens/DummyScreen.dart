
import 'package:flutter/material.dart';

class DummyScreen extends StatelessWidget {
  final String title;
  const DummyScreen(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Pantalla: $title')),
    );
  }
}
