import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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

  Future<Result<UsuarioModel, dynamic>> getUsuarioByUid({required String uid});

  Future<Result<List<UsuarioModel>, dynamic>> getAllUsuario();

  Future<Result<dynamic, dynamic>> addUsuario({
    String? email,
    String? phoneNumber,
    required String rol,
  });

  Future<Result<dynamic, dynamic>> updateUsuario({
    required String uid,
    required String nombre,
    required String apellido1,
    required String apellido2,
    required String email,
    String? password,
    required String telefono,
    required String fechaNacimiento,
    required String rol,
  });

  Future<void> signOut();

  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required String rol,
    required String solicitado,
    required BuildContext context,
  });

  Future<Result<dynamic, dynamic>> signUpPhoneNumber({
    required String rol,
    required String verificationId,
    required String smsCode,
  });

  Future<void> resetPassword({required String email});

  Future<Result<UsuarioModel, dynamic>> findUsuarioByTelefonoOrEmail({
    required String telefono,
    String? email,
  });

  Future<Result<dynamic, dynamic>> deleteUsuario();

  Future<Result<dynamic, dynamic>> deleteUsuarioByUid({
    required String uid,
  });
}
