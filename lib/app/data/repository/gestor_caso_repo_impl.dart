import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/gestor_casos_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class GestorCasosRepoImpl implements GestorCasosRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  GestorCasosRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'gestores_casos';

  @override
  Future<Result> addGestorCasos(String hospital) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'hospital': await EncryptData.encryptData(hospital),
    };

    try {
      return firebaseService
          .setDataOnDocument(
            collectionPath: collection,
            documentPath: usuarioUid,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result> deleteGestorCasos() {
    final currentUser = fireAuthService.currentUser()!;
    try {
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: currentUser.uid,
          )
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  @override
  Future<Result<GestorCasosModel, dynamic>> getGestorCasos() {
    final currentUser = fireAuthService.currentUser();

    try {
      return firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: currentUser!.uid,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<Success<GestorCasosModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(GestorCasosModel.fromJson(json));
  }

  @override
  Future<Result> updateGestorCasos(String hospital) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'hospital': await EncryptData.encryptData(hospital),
    };

    try {
      return firebaseService
          .updateDataOnDocument(
            collectionPath: collection,
            uuid: usuarioUid,
            data: data,
          )
          .then((value) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }
}
