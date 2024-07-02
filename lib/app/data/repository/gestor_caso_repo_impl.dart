import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  Future<Result> addGestorCasos({
    required String hospital,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'usuario_uid': usuarioUid,
      'hospital': await EncryptData.encryptData(hospital),
      'pacientes': jsonEncode([]),
    };

    try {
      return firebaseService
          .setDataOnDocument(
            collection: collection,
            document: usuarioUid,
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
    final currentUser = fireAuthService.currentUser()!;
    return _getGestorCasosFirebase(currentUser.uid);
  }

  Future<Success<GestorCasosModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(GestorCasosModel.fromJson(json));
  }

  @override
  Future<Result> updateGestorCasos({
    required String hospital,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'usuario_uid': usuarioUid,
      'hospital': await EncryptData.encryptData(hospital),
    };

    try {
      return firebaseService
          .updateDataOnDocument(
            collection: collection,
            document: usuarioUid,
            data: data,
          )
          .then((value) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<GestorCasosModel, dynamic>> getGestorCasosByUid(String uid) {
    return _getGestorCasosFirebase(uid);
  }

  Future<Result<GestorCasosModel, dynamic>> _getGestorCasosFirebase(
      String uid) async {
    try {
      return firebaseService
          .getFromDocument(
            collection: collection,
            document: uid,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  @override
  Future<void> relacionaGestorCasosPaciente({
    required String uidGestorCasos,
  }) async {
    try {
      final uidPaciente = fireAuthService.currentUser()!.uid;

      final json = {
        'pacientes': FieldValue.arrayUnion([uidPaciente]),
      };

      final docRef = firebaseService.getDocumentFromCollection(
        collection: collection,
        document: uidGestorCasos,
      );

      docRef.get().then(
        (d) async {
          if (d.exists) {
            await docRef.update(json);
          }
        },
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<Result> deleteGestorCasosByUid({required String uid}) {
    try {
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: uid,
          )
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }
}
