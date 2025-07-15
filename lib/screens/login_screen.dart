import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/usuario.dart';
import '../providers/auth_provider.dart';
import '../app_routes.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    final authProvider = context.read<AuthProvider>();
    authProvider.login(_email, _password).then((_) {
      final Usuario? user = authProvider.user;
      if (user != null) {
        // ignore: avoid_print
        print('Login: Usuario con rol ${user.rol} - ${user.nombre ?? ''}');
        Navigator.pushReplacementNamed(context, AppRoutes.home);
      } else {
        // Opcional: manejar error o estado de usuario nulo
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (authProvider.error != null)
                Text(authProvider.error!, style: const TextStyle(color: Colors.red)),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Correo electrónico'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => (value == null || value.isEmpty) ? 'Ingrese un correo' : null,
                onSaved: (value) => _email = value!.trim(),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Contraseña'),
                obscureText: true,
                validator: (value) => (value == null || value.isEmpty) ? 'Ingrese una contraseña' : null,
                onSaved: (value) => _password = value!.trim(),
              ),
              const SizedBox(height: 32),
              authProvider.isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Iniciar sesión'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
