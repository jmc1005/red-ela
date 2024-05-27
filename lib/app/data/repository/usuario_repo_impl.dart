import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/typedefs.dart';
import '../../domain/models/usuario/usuario_model.dart';
import '../../domain/repository/usuario_repo.dart';
import '../../utils/firebase/firebase_code_enum.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';
import '../services/local/session_service.dart';

class UsuarioRepoImpl extends UsuarioRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;
  final SessionService sessionService;

  UsuarioRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
    required this.sessionService,
  });

  final String collection = 'usuarios';

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuario() async {
    try {
      final currentUid = await sessionService.currentUid;

      return await firebaseService
          .getFromDocument(
        collectionPath: collection,
        documentPath: currentUid!,
      )
          .then(
        (json) async {
          final rol = json['rol'];
          final rolDecrypt = await EncryptData.decryptData(rol);

          if (rolDecrypt != null) {
            sessionService.saveRol(rolDecrypt);
          }
          return successFromJson(json);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuarioByUid(
      {required String uid}) async {
    try {
      return await firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: uid,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<Success<UsuarioModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(UsuarioModel.fromJson(json));
  }

  @override
  Future<bool> get isSignedIn async => fireAuthService.currentUser() != null;

  @override
  Future<Result<User, dynamic>> signIn(String email, String password) async {
    final result = await fireAuthService.signInWithEmailAndPassword(
      email,
      password,
    );

    if (result is User) {
      sessionService.saveCurrentUid(result.uid);
      return Success(result);
    }

    return const Error(FirebaseCode.invalidPassword);
  }

  @override
  Future<void> signOut() async {
    await fireAuthService.signOut();
  }

  @override
  Future<Result<dynamic, dynamic>> signUp(
    String email,
    String password,
    String rol,
  ) async {
    final result = await fireAuthService.createUserWithEmailAndPassword(
      email,
      password,
    );

    if (result is User) {
      final resultAdd = await addUsuario(email: email, rol: rol);

      return resultAdd.when(
        (success) => Success(success),
        (error) => Error(error),
      );
    }

    return Error(result);
  }

  @override
  Future<Result<dynamic, dynamic>> updateUsuario({
    required String uid,
    required String nombre,
    required String apellido1,
    required String apellido2,
    required String email,
    String? password,
    required String telefono,
    required String fechaNacimiento,
  }) async {
    try {
      final currentUser = fireAuthService.currentUser()!;
      final nombreEncrypt = await EncryptData.encryptData(nombre);
      final apellido1Encrypt = await EncryptData.encryptData(apellido1);
      final apellido2Encrypt = await EncryptData.encryptData(apellido2);
      final nombreCompletoEncrypt =
          '$nombreEncrypt $apellido1Encrypt $apellido2Encrypt';

      final data = {
        'uid': uid,
        'nombre': nombreEncrypt,
        'apellido1': apellido1Encrypt,
        'apellido2': apellido2Encrypt,
        'nombre_completo': nombreCompletoEncrypt,
        'email': email,
        'fecha_nacimiento': await EncryptData.encryptData(fechaNacimiento),
        'telefono': telefono,
      };

      if (currentUser.uid == uid &&
          currentUser.email == null &&
          password != null) {
        await fireAuthService.signInWithEmailAndPassword(email, password);
      }

      return await firebaseService
          .updateDataOnDocument(
            collectionPath: collection,
            uuid: uid,
            data: data,
          )
          .then((value) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> addUsuario({
    String? email,
    String? phoneNumber,
    required String rol,
  }) async {
    final currentUser = fireAuthService.currentUser()!;

    final data = {
      'uid': currentUser.uid,
      'email': email ?? '',
      'rol': await EncryptData.encryptData(rol),
      'telefono': phoneNumber != null ? phoneNumber.replaceAll('+34', '') : '',
    };

    try {
      return firebaseService
          .setDataOnDocument(
            collectionPath: collection,
            documentPath: currentUser.uid,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteUsuario() async {
    final currentUser = fireAuthService.currentUser()!;

    try {
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: currentUser.uid,
          )
          .then((value) => borrarUsuarioAuth());
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  Future<Result<dynamic, dynamic>> borrarUsuarioAuth() {
    try {
      return fireAuthService
          .delete()
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  @override
  Future<Result<List<UsuarioModel>, dynamic>> getAllUsuario() async {
    final List<UsuarioModel> list = [];
    try {
      final usuarios = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in usuarios) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(UsuarioModel.fromJson(json));
      }

      return Success(list);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }

  @override
  Future<Result<User, dynamic>> signUpPhoneNumber({
    required String rol,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final result = await fireAuthService.phoneCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      final currentUser = fireAuthService.currentUser()!;

      if (result is User) {
        sessionService.saveCurrentUid(result.uid);

        final resultAdd = await addUsuario(
          rol: rol,
          phoneNumber: currentUser.phoneNumber,
        );

        return resultAdd.when(
          (success) => Success(result),
          (error) => Error(error),
        );
      }
    } on FirebaseAuthException catch (e) {
      return Error(e.code);
    }

    return const Error('user-not-found');
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required String rol,
    required String solicitado,
    required BuildContext context,
  }) async {
    await fireAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      rol: rol,
      solicitado: solicitado,
      context: context,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    fireAuthService.resetPassword(email: email);
  }
}
