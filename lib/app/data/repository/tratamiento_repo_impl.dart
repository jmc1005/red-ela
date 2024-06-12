import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/tratamiento/tratamiento_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/tratamiento_repo.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class TratamientoRepoImpl implements TratamientoRepo {
  final FirebaseService firebaseService;

  TratamientoRepoImpl({
    required this.firebaseService,
  });

  final String collection = 'tratamientos';

  @override
  Future<Result> addTratamiento({
    required String tratamiento,
    required String descripcion,
  }) async {
    const uuid = Uuid();
    final uuidDoc = uuid.v1();

    final data = {
      'uuid': uuidDoc,
      'tratamiento': await EncryptData.encryptData(tratamiento),
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
  Future<Result<TratamientoModel, dynamic>> getTratamiento(
      {required String uuid}) {
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

  Future<Success<TratamientoModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(TratamientoModel.fromJson(json));
  }

  @override
  Future<Result> updateTratamiento({
    required String uuid,
    required String tratamiento,
    required String descripcion,
  }) async {
    try {
      return firebaseService.updateDataOnDocument(
        collection: collection,
        document: uuid,
        data: {
          'uuid': uuid,
          'tratamiento': await EncryptData.encryptData(tratamiento),
          'descripcion': await EncryptData.encryptData(descripcion),
        },
      ).then((json) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteTratamiento(
      {required String uuid}) async {
    try {
      final usuarios = await FirebaseFirestore.instance
          .collection('gestores')
          .where('tratamiento', isEqualTo: await EncryptData.encryptData(uuid))
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
  Future<Result<List<TratamientoModel>, dynamic>> getTratamientos() async {
    try {
      final List<TratamientoModel> list = [];
      final tratamientos = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in tratamientos) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(TratamientoModel.fromJson(json));
      }

      return Success(list);
    } catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }
}
