import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/rol/rol_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/rol_repo.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class RolRepoImpl implements RolRepo {
  final FirebaseService firebaseService;

  RolRepoImpl({
    required this.firebaseService,
  });

  final String collection = 'roles';

  @override
  Future<Result> addRol(String rol, String descripcion) async {
    final data = {
      'rol': await EncryptData.encryptData(rol),
      'descripcion': await EncryptData.encryptData(descripcion),
    };
    try {
      return firebaseService
          .setDataOnDocument(
            collectionPath: collection,
            documentPath: rol,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result<RolModel, dynamic>> getRol(String rol) {
    try {
      return firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: rol,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<Success<RolModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(RolModel.fromJson(json));
  }

  @override
  Future<Result> updateRol(String uuid, String rol, String descripcion) async {
    try {
      return firebaseService.updateDataOnDocument(
        collectionPath: collection,
        uuid: uuid,
        data: {
          'rol': await EncryptData.encryptData(rol),
          'descripcion': await EncryptData.encryptData(descripcion),
        },
      ).then((json) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteRol(String rol) async {
    try {
      final usuarios = await FirebaseFirestore.instance
          .collection('users')
          .where('rol', isEqualTo: rol)
          .get();

      if (usuarios.docs.isNotEmpty) {
        return const Error('data-delete-failed');
      }
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: rol,
          )
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }
}
