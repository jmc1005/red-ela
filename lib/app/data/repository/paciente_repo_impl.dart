import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

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
    String? cuidador,
    String? gestorCasos,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = await getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
      gestorCasos,
    );

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
  Future<Result> updatePaciente({
    String? tratamiento,
    String? fechaDiagnostico,
    String? inicio,
    String? cuidador,
    String? gestorCasos,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = await getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
      gestorCasos,
    );

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
    String? cuidador,
    String? gestorCasos,
  ) async {
    final data = {
      'usuario_uid': usuarioUid,
      'tratamiento': tratamiento != null
          ? await EncryptData.encryptData(tratamiento)
          : null,
      'fecha_diagnostico': fechaDiagnostico != null
          ? await EncryptData.encryptData(fechaDiagnostico)
          : null,
      'inicio': inicio != null ? await EncryptData.encryptData(inicio) : null,
    };

    if (cuidador != null) {
      data['cuidador'] = cuidador;
    }

    if (gestorCasos != null) {
      data['gestor_casos'] = gestorCasos;
    }

    return data;
  }

  @override
  Future<Result<List<String>, dynamic>> getAllPacientesByUidCuidador({
    required String uidCuidador,
    required String email,
  }) async {
    final filterCuidadorUid = Filter(
      'cuidador',
      isEqualTo: uidCuidador,
    );

    final data = await firebaseService
        .getCollection(collection: collection)
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
  Future<void> relacionaPacienteCuidador({
    required String uidPaciente,
  }) async {
    try {
      final uidCuidador = fireAuthService.currentUser()!.uid;

      await firebaseService.updateDataOnDocument(
        collection: collection,
        document: uidPaciente,
        data: {
          'cuidador': uidCuidador,
        },
      ).then((value) => const Success('data-updated'));
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
            collection: collection,
            document: uid,
          )
          .then((json) async => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }
}
