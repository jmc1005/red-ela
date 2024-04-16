import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:red_ela/app/presentation/modules/sign/controllers/sign_controller.dart';
import 'package:red_ela/app/presentation/modules/sign/controllers/state/sign_state.dart';
import 'package:red_ela/firebase_options.dart';
import 'package:red_ela/red_ela.dart';
import 'app/data/services/local/session_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final sessionService = SessionService(const FlutterSecureStorage());

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final firestore = FirebaseFirestore.instance;

  firestore.settings = const Settings(
    persistenceEnabled: true,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SignController>(
          create: (context) => SignController(SignState()),
        ),
      ],
      child: Redela(),
    ),
  );
}
