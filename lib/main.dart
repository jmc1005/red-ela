import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';

import 'app/data/firebase/fireauth_service.dart';
import 'app/data/firebase/firebase_service.dart';

import 'app/data/repository/connection_repo_impl.dart';
import 'app/data/repository/cuidador_repo_impl.dart';
import 'app/data/repository/gestor_caso_repo_impl.dart';
import 'app/data/repository/invitacion_repo_impl.dart';
import 'app/data/repository/paciente_repo_impl.dart';
import 'app/data/repository/rol_repo_impl.dart';
import 'app/data/repository/usuario_repo_impl.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/check_connection.dart';
import 'app/domain/repository/connection_repo.dart';
import 'app/domain/repository/cuidador_repo.dart';
import 'app/domain/repository/gestor_casos_repo.dart';
import 'app/domain/repository/invitacion_repo.dart';
import 'app/domain/repository/paciente_repo.dart';
import 'app/domain/repository/rol_repo.dart';
import 'app/domain/repository/usuario_repo.dart';
import 'app/presentation/modules/citas/controllers/cita_controller.dart';
import 'app/presentation/modules/cuidador/controllers/cuidador_controller.dart';
import 'app/presentation/modules/gestor_casos/controllers/gestor_casos_controller.dart';
import 'app/presentation/modules/invitacion/controllers/invitacion_controller.dart';
import 'app/presentation/modules/invitacion/controllers/state/invitacion_state.dart';
import 'app/presentation/modules/otp/controllers/otp_controller.dart';
import 'app/presentation/modules/otp/controllers/state/otp_state.dart';
import 'app/presentation/modules/paciente/controllers/paciente_controller.dart';
import 'app/presentation/modules/rol/controllers/rol_controller.dart';
import 'app/presentation/modules/sign/controllers/sign_controller.dart';
import 'app/presentation/modules/sign/controllers/state/sign_state.dart';
import 'app/presentation/modules/user/controllers/usuario_controller.dart';
import 'firebase_options.dart';
import 'red_ela.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionService = SessionService(const FlutterSecureStorage());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  firestore.settings = const Settings(
    persistenceEnabled: true,
  );

  final gestorCasosRepo = GestorCasosRepoImpl(
    firebaseService: FirebaseService(firestore: firestore),
    fireAuthService: FireAuthService(firebaseAuth: firebaseAuth),
  );

  final pacienteRepo = PacienteRepoImpl(
      firebaseService: FirebaseService(firestore: firestore),
      fireAuthService: FireAuthService(firebaseAuth: firebaseAuth),
      gestorCasosRepo: gestorCasosRepo);

  final cuidadorRepo = CuidadorRepoImpl(
      firebaseService: FirebaseService(firestore: firestore),
      fireAuthService: FireAuthService(firebaseAuth: firebaseAuth),
      pacienteRepo: pacienteRepo);

  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectionRepo>(
          create: (_) => ConnectionRepoImpl(
            Connectivity(),
            CheckConnection(),
          ),
        ),
        Provider<SessionService>(
          create: (_) => sessionService,
        ),
        Provider<RolRepo>(
          create: (_) => RolRepoImpl(
            firebaseService: FirebaseService(firestore: firestore),
          ),
        ),
        Provider<UsuarioRepo>(
          create: (_) => UsuarioRepoImpl(
            firebaseService: FirebaseService(firestore: firestore),
            fireAuthService: FireAuthService(firebaseAuth: firebaseAuth),
            sessionService: sessionService,
          ),
        ),
        Provider<PacienteRepo>(
          create: (_) => pacienteRepo,
        ),
        Provider<CuidadorRepo>(
          create: (_) => cuidadorRepo,
        ),
        Provider<GestorCasosRepo>(
          create: (_) => gestorCasosRepo,
        ),
        Provider<InvitacionRepo>(
          create: (_) => InvitacionRepoImpl(
            firebaseService: FirebaseService(firestore: firestore),
            fireAuthService: FireAuthService(firebaseAuth: firebaseAuth),
          ),
        ),
        Provider<PacienteController>(
          create: (context) => PacienteController(
            context: context,
            pacienteRepo: pacienteRepo,
          ),
        ),
        Provider<CuidadorController>(
          create: (context) => CuidadorController(
            context: context,
            cuidadorRepo: cuidadorRepo,
          ),
        ),
        Provider<GestorCasosController>(
          create: (context) => GestorCasosController(
            context: context,
            gestorCasosRepo: gestorCasosRepo,
          ),
        ),
        Provider<OTPController>(
          create: (context) => OTPController(
            const OTPState(),
            usuarioRepo: context.read(),
            invitacionRepo: context.read(),
            pacienteRepo: context.read(),
            cuidadorRepo: context.read(),
            gestorCasosRepo: context.read(),
            sessionService: sessionService,
          ),
        ),
        Provider<RolController>(
          create: (_) => RolController(
            rolRepo: RolRepoImpl(
              firebaseService: FirebaseService(firestore: firestore),
            ),
          ),
        ),
        Provider<CitaController>(
          create: (_) => CitaController(),
        ),
        ChangeNotifierProvider<SignController>(
          create: (context) => SignController(
            const SignState(),
            usuarioRepo: context.read(),
            context: context,
          ),
        ),
        ChangeNotifierProvider<UsuarioController>(
          create: (context) => UsuarioController(
            usuarioRepo: context.read(),
            pacienteController: context.read(),
            cuidadorController: context.read(),
            gestorCasosController: context.read(),
            sessionService: sessionService,
            signController: SignController(
              const SignState(),
              usuarioRepo: context.read(),
              context: context,
            ),
          ),
        ),
        ChangeNotifierProvider<OTPController>(
          create: (context) => OTPController(
            const OTPState(),
            usuarioRepo: context.read(),
            invitacionRepo: context.read(),
            pacienteRepo: context.read(),
            cuidadorRepo: context.read(),
            gestorCasosRepo: context.read(),
            sessionService: sessionService,
          ),
        ),
        ChangeNotifierProvider<RolController>(
          create: (context) => RolController(
            rolRepo: RolRepoImpl(
              firebaseService: FirebaseService(firestore: firestore),
            ),
          ),
        ),
        ChangeNotifierProvider<InvitacionController>(
          create: (context) => InvitacionController(
            const InvitacionState(),
            invitacionRepo: context.read(),
            usuarioRepo: context.read(),
            sessionService: sessionService,
          ),
        ),
        ChangeNotifierProvider<CitaController>(
          create: (context) => CitaController(),
        ),
      ],
      child: const Redela(),
    ),
  );
}
