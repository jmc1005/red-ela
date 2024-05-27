import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/invitacion/invitacion_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/invitacion_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class InvitacionRepoImpl extends InvitacionRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  InvitacionRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'invitaciones';

  @override
  Future<Result> addInvitacion({
    required String telefono,
    required String rol,
  }) async {
    final currentUser = fireAuthService.currentUser();
    final encrypRol = await EncryptData.encryptData(rol);

    final data = {
      'rol': encrypRol,
      'solicitado': currentUser!.uid,
      'estado': await EncryptData.encryptData('pendiente'),
    };

    try {
      return firebaseService
          .setDataOnDocument(
            collectionPath: collection,
            documentPath: encrypRol,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result<InvitacionModel, dynamic>> getInvitacion(
      String telefono) async {
    try {
      // pendiente: 8CLTV7WsWStyyJtJkRfbWA==
      return firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: telefono,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<Success<InvitacionModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(InvitacionModel.fromJson(json));
  }

  @override
  Future<Result> updateInvitacion(String telefono, String estado) async {
    try {
      return firebaseService.updateFieldsOnDocument(
        collectionPath: collection,
        documentPath: telefono,
        data: {
          'estado': await EncryptData.encryptData(estado),
        },
      ).then((value) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }
}
