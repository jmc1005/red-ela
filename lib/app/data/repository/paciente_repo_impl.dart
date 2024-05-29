import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/cuidador/cuidador_model.dart';
import '../../domain/models/paciente/paciente_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/gestor_casos_repo.dart';
import '../../domain/repository/paciente_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class PacienteRepoImpl implements PacienteRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;
  final GestorCasosRepo gestorCasosRepo;

  PacienteRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
    required this.gestorCasosRepo,
  });

  final String collection = 'pacientes';

  @override
  Future<Result> addPaciente({
    required String tratamiento,
    required String fechaDiagnostico,
    required String inicio,
    CuidadorModel? cuidador,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = await getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
    );

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
  Future<Result> updatePaciente({
    String? tratamiento,
    String? fechaDiagnostico,
    String? inicio,
    CuidadorModel? cuidador,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = await getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
    );

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

  @override
  Future<Result> deletePaciente() {
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
  Future<Result<PacienteModel, dynamic>> getPaciente() {
    final currentUser = fireAuthService.currentUser()!;
    return _getPacienteFirebase(currentUser.uid);
  }

  Future<Success<PacienteModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(PacienteModel.fromJson(json));
  }

  Future<Json> getDataPaciente(
    String usuarioUid,
    String? tratamiento,
    String? fechaDiagnostico,
    String? inicio,
    CuidadorModel? cuidador,
  ) async {
    final data = {
      'usuario_uid': await EncryptData.encryptData(usuarioUid),
      'tratamiento': tratamiento != null
          ? await EncryptData.encryptData(tratamiento)
          : null,
      'fecha_diagnostico': fechaDiagnostico,
      'inicio': inicio,
    };

    if (cuidador != null) {
      if (cuidador.usuarioUid.isNotEmpty) {
        data['cuidador'] = jsonEncode(
          {'usuario_uid': cuidador.usuarioUid},
        );
      }
    }

    return data;
  }

  @override
  Future<Result<List<String>, dynamic>> getAllPacientesByUidCuidador({
    required String uidCuidador,
    required String email,
  }) async {
    final filterCuidadorUid = Filter(
      'cuidador.usuario_uid',
      isEqualTo: uidCuidador,
    );

    final data = await firebaseService
        .getCollection(collectionPath: collection)
        .where(filterCuidadorUid)
        .get();

    final List<String> dataList = data.docs
        .map(
          (e) => PacienteModel.fromJson(e.data()).usuarioUid,
        )
        .toList();

    return Future.value(Success(dataList));
  }

  @override
  Future<void> updatePacienteRelacion({required String solicitado}) async {
    final currentUser = fireAuthService.currentUser()!;

    try {
      await firebaseService.setDataOnDocument(
        collectionPath: collection,
        documentPath: currentUser.uid,
        data: {
          'gestor_caso': solicitado,
        },
      ).then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> addCuidador(
      {required String uidPaciente, required String uidCuidador}) async {
    try {
      await firebaseService.updateFieldsOnDocument(
        collectionPath: collection,
        documentPath: uidPaciente,
        data: {
          'cuidador': uidCuidador,
        },
      ).then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<Result<PacienteModel, dynamic>> getPacienteByUid(String uid) {
    return _getPacienteFirebase(uid);
  }

  Future<Result<PacienteModel, dynamic>> _getPacienteFirebase(String uid) {
    try {
      return firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: uid,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }
}
