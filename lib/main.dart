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
import 'app/data/repository/rol_repo_impl.dart';
import 'app/data/repository/usuario_repo_impl.dart';
import 'app/data/services/local/session_service.dart';
import 'app/data/services/remote/check_connection.dart';
import 'app/domain/repository/connection_repo.dart';
import 'app/domain/repository/rol_repo.dart';
import 'app/domain/repository/usuario_repo.dart';
import 'app/presentation/modules/sign/controllers/sign_controller.dart';
import 'app/presentation/modules/sign/controllers/state/sign_state.dart';
import 'app/presentation/modules/user/controllers/usuario_controller.dart';
import 'firebase_options.dart';
import 'red_ela.dart';

void main() async {
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

  runApp(
    MultiProvider(
      providers: [
        Provider<ConnectionRepo>(
          create: (_) => ConnectionRepoImpl(
            Connectivity(),
            CheckConnection(),
          ),
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
          ),
        ),
        ChangeNotifierProvider<SignController>(
          create: (context) => SignController(
            const SignState(),
            usuarioRepo: context.read(),
          ),
        ),
        ChangeNotifierProvider<UsuarioController>(
          create: (context) => UsuarioController(
            usuarioRepo: context.read(),
          ),
        ),
      ],
      child: const Redela(),
    ),
  );
}
