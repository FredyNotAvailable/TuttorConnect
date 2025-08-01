import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tutor_connect/data_sources/asistencia_tutoria_data_source.dart';
import 'package:tutor_connect/data_sources/aula_data_source.dart';
import 'package:tutor_connect/data_sources/carrera_data_source.dart';
import 'package:tutor_connect/data_sources/malla_curricular_data_source.dart';
import 'package:tutor_connect/data_sources/materia_data_source.dart';
import 'package:tutor_connect/data_sources/matricula_data_source.dart';
import 'package:tutor_connect/data_sources/plan_docente_data_source.dart';
import 'package:tutor_connect/data_sources/solicitud_tutoria_data_source.dart';
import 'package:tutor_connect/data_sources/tutoria_data_source.dart';
import 'package:tutor_connect/providers/asistencia_tutoria_provider.dart';
import 'package:tutor_connect/providers/aula_provider.dart';
import 'package:tutor_connect/providers/carrera_provider.dart';
import 'package:tutor_connect/providers/malla_curricular_provider.dart';
import 'package:tutor_connect/providers/materia_provider.dart';
import 'package:tutor_connect/providers/matricula_provider.dart';
import 'package:tutor_connect/providers/plan_docente_provider.dart';
import 'package:tutor_connect/providers/solicitud_tutoria_provider.dart';
import 'package:tutor_connect/providers/tutoria_provider.dart';
import 'package:tutor_connect/services/asistencia_tutoria_service.dart';
import 'package:tutor_connect/services/aula_service.dart';
import 'package:tutor_connect/services/carrera_service.dart';
import 'package:tutor_connect/services/malla_curricular_service.dart';
import 'package:tutor_connect/services/materia_service.dart';
import 'package:tutor_connect/services/matricula_service.dart';
import 'package:tutor_connect/services/plan_docente_service.dart';
import 'package:tutor_connect/services/solicitud_tutoria_service.dart';
import 'package:tutor_connect/services/tutoria_service.dart';

import 'data_sources/auth_data_source.dart';
import 'data_sources/usuario_data_source.dart';
import 'services/auth_service.dart';
import 'services/usuario_service.dart';
import 'providers/auth_provider.dart';
import 'providers/usuario_provider.dart';
import 'app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final authRepository = AuthDataSource();
  final usuarioRepository = UsuarioDataSource();
  final matriculaRepository = MatriculaDataSource();
  final carreraRepository = CarreraDataSource();
  final materiaRepository = MateriaDataSource();
  final mallaCurricularRepository = MallaCurricularDataSource();
  final planDocenteRepository = PlanDocenteDataSource();
  final aulaRepository = AulaDataSource();
  final tutoriaRepository = TutoriaDataSource();
  final asistenciaTutoriaRepository = AsistenciaTutoriaDataSource();
  final solicitudRepository = SolicitudTutoriaDataSource();


  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider(AuthService(authRepository),),),
        ChangeNotifierProvider(create: (_) => UsuarioProvider(UsuarioService(usuarioRepository),),),
        ChangeNotifierProvider(create: (_) => MatriculaProvider(MatriculaService(matriculaRepository),),),
        ChangeNotifierProvider(create: (_) => CarreraProvider(CarreraService(carreraRepository),),),
        ChangeNotifierProvider(create: (_) => MateriaProvider(MateriaService(materiaRepository),),),
        ChangeNotifierProvider(create: (_) => MallaCurricularProvider(MallaCurricularService(mallaCurricularRepository),),),
        ChangeNotifierProvider(create: (_) => PlanDocenteProvider(PlanDocenteService(planDocenteRepository),),),
        ChangeNotifierProvider(create: (_) => AulaProvider(AulaService(aulaRepository),),),
        ChangeNotifierProvider(create: (_) => TutoriaProvider(TutoriaService(tutoriaRepository),),),
        ChangeNotifierProvider(create: (_) => AsistenciaTutoriaProvider(AsistenciaTutoriaService(asistenciaTutoriaRepository),),),
        ChangeNotifierProvider(create: (_) => SolicitudTutoriaProvider(SolicitudTutoriaService(solicitudRepository),),),
      ],
      child: const TutorConnectApp(),
    ),
  );
}

class TutorConnectApp extends StatelessWidget {
  const TutorConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TutorConnect',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.indigo),
      initialRoute: AppRoutes.login,
      routes: AppRoutes.getRoutes(),
    );
  }
}
