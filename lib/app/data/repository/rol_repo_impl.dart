import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

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
  Future<Result> addRol({
    required String rol,
    required String descripcion,
  }) async {
    const uuid = Uuid();
    final uuidDoc = uuid.v1();

    final data = {
      'uuid': uuidDoc,
      'rol': await EncryptData.encryptData(rol),
      'descripcion': await EncryptData.encryptData(descripcion),
    };
    try {
      return firebaseService
          .setDataOnDocument(
            collection: collection,
            document: uuidDoc,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result<RolModel, dynamic>> getRol({required String uuid}) {
    try {
      return firebaseService
          .getFromDocument(
            collection: collection,
            document: uuid,
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
  Future<Result> updateRol({
    required String uuid,
    required String rol,
    required String descripcion,
  }) async {
    try {
      return firebaseService.updateDataOnDocument(
        collection: collection,
        document: uuid,
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
  Future<Result<dynamic, dynamic>> deleteRol({required String uuid}) async {
    try {
      final responseRol = await getRol(uuid: uuid);
      var rol = '';

      responseRol.when(
        (success) => rol = success.rol,
        (error) => null,
      );

      final usuarios = await FirebaseFirestore.instance
          .collection('usuarios')
          .where('rol', isEqualTo: await EncryptData.encryptData(rol))
          .get();

      if (usuarios.docs.isNotEmpty) {
        return const Error('data-delete-failed');
      }
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: uuid,
          )
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  @override
  Future<Result<List<RolModel>, dynamic>> getRoles() async {
    try {
      final List<RolModel> list = [];
      final roles = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in roles) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(RolModel.fromJson(json));
      }

      return Success(list);
    } catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }
}
