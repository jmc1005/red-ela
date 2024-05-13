import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';

import '../models/usuario/usuario_model.dart';

abstract class UsuarioRepo {
  Future<bool> get isSignedIn;

  Future<Result<User, dynamic>> signIn(String email, String password);

  Future<Result<dynamic, dynamic>> signUp(
    String email,
    String password,
    String rol,
  );

  Future<Result<UsuarioModel, dynamic>> getUsuario();

  Future<Result<List<UsuarioModel>, dynamic>> getAllUsuario();

  Future<Result<dynamic, dynamic>> addUsuario(
    String email,
    String rol,
  );

  Future<Result<dynamic, dynamic>> updateUsuario(
    String nombre,
    String apellido1,
    String apellido2,
    String email,
    String fechaNacimiento,
    String rol,
  );

  Future<Result<dynamic, dynamic>> deleteUsuario();

  Future<void> signOut();
}
