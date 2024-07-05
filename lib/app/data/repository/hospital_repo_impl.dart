import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/hospital/hospital_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/hospital_repo.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class HospitalRepoImpl implements HospitalRepo {
  final FirebaseService firebaseService;

  HospitalRepoImpl({
    required this.firebaseService,
  });

  final String collection = 'hospitales';

  @override
  Future<Result> addHospital({
    required String hospital,
  }) async {
    const uuid = Uuid();
    final uuidDoc = uuid.v1();

    final data = {
      'uuid': uuidDoc,
      'hospital': await EncryptData.encryptData(hospital),
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
  Future<Result<HospitalModel, dynamic>> getHospital({required String uuid}) {
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

  Future<Success<HospitalModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(HospitalModel.fromJson(json));
  }

  @override
  Future<Result> updateHospital({
    required String uuid,
    required String hospital,
  }) async {
    try {
      return firebaseService.updateDataOnDocument(
        collection: collection,
        document: uuid,
        data: {
          'uuid': uuid,
          'hospital': await EncryptData.encryptData(hospital),
        },
      ).then((json) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteHospital(
      {required String uuid}) async {
    try {
      final usuarios = await FirebaseFirestore.instance
          .collection('gestores_casos')
          .where('hospital', isEqualTo: await EncryptData.encryptData(uuid))
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
  Future<Result<List<HospitalModel>, dynamic>> getHospitales() async {
    try {
      final List<HospitalModel> list = [];
      final tratamientos = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in tratamientos) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(HospitalModel.fromJson(json));
      }

      return Success(list);
    } catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }
}
