import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/cita/cita_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/cita_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class CitaRepoImpl implements CitaRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  CitaRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'citas';

  @override
  Future<Result> addCita({
    required String uidPaciente,
    required String asunto,
    required String fecha,
    required String horaInicio,
    required String horaFin,
    required String lugar,
    String? notas,
  }) async {
    const uuid = Uuid();
    final uuidDoc = uuid.v1();

    final uidGestorCasos = fireAuthService.currentUser()!.uid;

    final data = {
      'uuid': uuidDoc,
      'uid_paciente': uidPaciente,
      'uid_gestor_casos': uidGestorCasos,
      'asunto': await EncryptData.encryptData(asunto),
      'fecha': await EncryptData.encryptData(fecha),
      'hora_inicio': await EncryptData.encryptData(horaInicio),
      'hora_fin': await EncryptData.encryptData(horaFin),
      'lugar': await EncryptData.encryptData(lugar),
      'notas': notas != null ? await EncryptData.encryptData(notas) : null,
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
  Future<Result<CitaModel, dynamic>> getCita({required String uuid}) {
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

  Future<Success<CitaModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(CitaModel.fromJson(json));
  }

  @override
  Future<Result> updateCita({
    required String uuid,
    required String uidPaciente,
    required String asunto,
    required String fecha,
    required String horaInicio,
    required String horaFin,
    required String lugar,
    String? notas,
  }) async {
    try {
      final uidGestorCasos = fireAuthService.currentUser()!.uid;

      final data = {
        'uuid': uuid,
        'uid_paciente': uidPaciente,
        'uid_gestor_casos': uidGestorCasos,
        'asunto': await EncryptData.encryptData(asunto),
        'fecha': await EncryptData.encryptData(fecha),
        'hora_inicio': await EncryptData.encryptData(horaInicio),
        'hora_fin': await EncryptData.encryptData(horaFin),
        'lugar': await EncryptData.encryptData(lugar),
        'notas': notas != null ? await EncryptData.encryptData(notas) : null,
      };

      return firebaseService
          .updateDataOnDocument(
            collection: collection,
            document: uuid,
            data: data,
          )
          .then((json) => const Success('data-updated'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteCita({required String uuid}) async {
    try {
      final usuarios = await FirebaseFirestore.instance
          .collection('gestores')
          .where('cita', isEqualTo: await EncryptData.encryptData(uuid))
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
  Future<Result<List<CitaModel>, dynamic>> getCitas() async {
    try {
      final List<CitaModel> list = [];
      final citas = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in citas) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(CitaModel.fromJson(json));
      }

      return Success(list);
    } catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }
}
