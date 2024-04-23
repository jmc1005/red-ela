import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/usuario/usuario_model.dart';
import '../../domain/repository/usuario_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';

class UsuarioRepoImpl extends UsuarioRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  UsuarioRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'users';

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuario() async {
    final currentUser = fireAuthService.currentUser();
    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: currentUser!.uid,
        )
        .then((json) => Success(UsuarioModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
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
      return Success(result);
    }

    return const Error('user-not-found');
  }

  @override
  Future<void> signOut() async {
    await fireAuthService.signOut();
  }

  @override
  Future<Result<dynamic, dynamic>> signUp(String email, String password) async {
    final result = await fireAuthService.createUserWithEmailAndPassword(
      email,
      password,
    );

    if (result is User) {
      final resultAdd = await addUsuario(email);

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
    List<String> roles,
  ) async {
    final currentUser = fireAuthService.currentUser()!;

    final data = {
      'uid': currentUser.uid,
      'nombre': nombre,
      'apellido1': apellido1,
      'apellido2': apellido2,
      'email': currentUser.email,
      'roles': jsonEncode(roles)
    };

    return firebaseService
        .updateDataOnDocument(
          collectionPath: collection,
          uuid: currentUser.uid,
          data: data,
        )
        .then((value) => const Success('data-updated'))
        .catchError((error) => const Error('data-update-failed'));
  }

  @override
  Future<Result<dynamic, dynamic>> addUsuario(String email) {
    final currentUser = fireAuthService.currentUser()!;
    final roles = [];

    final data = {
      'uid': currentUser.uid,
      'email': currentUser.email,
      'nombre': '',
      'apellido1': '',
      'apellido2': '',
      'roles': roles,
    };

    return firebaseService
        .setDataOnDocument(
          collectionPath: collection,
          documentPath: currentUser.uid,
          data: data,
        )
        .then((value) => const Success('data-added'))
        .catchError((error) => const Error('data-add-failed'));
  }

  @override
  Future<Result<dynamic, dynamic>> deleteUsuario() async {
    final currentUser = fireAuthService.currentUser()!;
    return firebaseService
        .deleteDocumentFromCollection(
          collectionPath: collection,
          uid: currentUser.uid,
        )
        .then((value) => fireAuthService
            .delete()
            .then((value) => const Success('data-deleted'))
            .catchError((error) => const Error('data-delete-failed')))
        .catchError((error) => const Error('data-delete-failed'));
  }

  @override
  Future<Result<List<UsuarioModel>, dynamic>> getAllUsuario() async {
    final List<UsuarioModel> list = [];

    final usuarios = await firebaseService.getFromCollection(
      collectionPath: collection,
    );

    for (final element in usuarios) {
      list.add(UsuarioModel.fromJson(element));
    }

    return Success(list);
  }
}
