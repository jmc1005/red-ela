import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/typedefs.dart';
import '../../domain/models/usuario/usuario_model.dart';
import '../../domain/repository/usuario_repo.dart';
import '../../utils/constants/app_constants.dart';
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

    return const Error('user-not-found');
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
  Future<Result<dynamic, dynamic>> updateUsuario(
    String nombre,
    String apellido1,
    String apellido2,
    String email,
    String fechaNacimiento,
    String rol,
  ) async {
    try {
      final currentUser = fireAuthService.currentUser()!;

      final format = DateFormat(AppConstants.formatDate);
      final dateTime = format.parse(fechaNacimiento);

      final data = {
        'uid': currentUser.uid,
        'nombre': await EncryptData.encryptData(nombre),
        'apellido1': await EncryptData.encryptData(apellido1),
        'apellido2': await EncryptData.encryptData(apellido2),
        'email': email,
        'fecha_nacimiento': dateTime,
        'rol': await EncryptData.encryptData(rol)
      };

      if (currentUser.email != email) {
        fireAuthService.updateEmail(email);
      }

      return await firebaseService
          .updateDataOnDocument(
            collectionPath: collection,
            uuid: currentUser.uid,
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
    required String rol,
    String? phonNumber,
  }) async {
    final currentUser = fireAuthService.currentUser()!;

    final data = {
      'uid': currentUser.uid,
      'email': currentUser.email ?? '',
      'rol': await EncryptData.encryptData(rol),
      'telefono': currentUser.phoneNumber != null
          ? currentUser.phoneNumber!.replaceAll('+34', '')
          : '',
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
        list.add(UsuarioModel.fromJson(element));
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
          phonNumber: currentUser.phoneNumber,
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
    required BuildContext context,
  }) async {
    await fireAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      rol: rol,
      context: context,
    );
  }
}
