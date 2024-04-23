import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';

import '../models/usuario/usuario_model.dart';

abstract class UsuarioRepo {
  Future<bool> get isSignedIn;

  Future<Result<User, dynamic>> signIn(String email, String password);

  Future<Result<dynamic, dynamic>> signUp(String email, String password);

  Future<Result<UsuarioModel, dynamic>> getUsuario();

  Future<Result<dynamic, dynamic>> addUsuario(
    String email,
  );

  Future<Result<dynamic, dynamic>> updateUsuario(
    String nombre,
    String apellido1,
    String apellido2,
    String email,
    List<String> roles,
  );

  Future<Result<dynamic, dynamic>> deleteUsuario();

  Future<void> signOut();
}
