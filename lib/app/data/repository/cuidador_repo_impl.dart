import 'dart:convert';

import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/cuidador/cuidador_model.dart';

import '../../domain/repository/cuidador_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';

class CuidadorRepoImpl implements CuidadorRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  CuidadorRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'cuidadores';
  final String collectionPacientes = 'pacientes';

  @override
  Future<Result> addCuidador(String relacion) {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = {
      'usuario_uid': usuarioUid,
      'relacion': relacion,
    };

    return firebaseService
        .setDataOnDocument(
          collectionPath: collection,
          documentPath: usuarioUid,
          data: data,
        )
        .then((value) => const Success('data-added'))
        .catchError((error) => const Error('data-add-failed'));
  }

  @override
  Future<Result> deleteCuidador() {
    final currentUser = fireAuthService.currentUser()!;

    return firebaseService
        .deleteDocumentFromCollection(
          collectionPath: collection,
          uid: currentUser.uid,
        )
        .then((value) => const Success('data-deleted'))
        .catchError((error) => const Error('data-delete-failed'));
  }

  @override
  Future<Result<CuidadorModel, dynamic>> getCuidador() {
    final currentUser = fireAuthService.currentUser();

    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: currentUser!.uid,
        )
        .then((json) => Success(CuidadorModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
  }

  @override
  Future<Result> updateCuidador(
    String relacion,
    List<String> pacientes,
  ) {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = {
      'usuario_uid': usuarioUid,
      'pacientes': jsonEncode(pacientes),
      'relacion': relacion,
    };

    return firebaseService
        .updateDataOnDocument(
          collectionPath: collection,
          uuid: usuarioUid,
          data: data,
        )
        .then((value) => const Success('data-updated'))
        .catchError((error) => const Error('data-update-failed'));
  }

  @override
  Future<Result<CuidadorModel, dynamic>> findCuidadorByEmail(
    String email,
  ) async {
    return firebaseService
        .findDocumentByFieldIsEqualToValue(
          collectionPath: collection,
          field: 'email',
          value: email,
        )
        .then((json) => Success(CuidadorModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
  }

  @override
  Future<Result<CuidadorModel, dynamic>> findCuidadorByUid(String uidCuidador) {
    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: uidCuidador,
        )
        .then((json) => Success(CuidadorModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
  }
}
