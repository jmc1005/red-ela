import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/cuidador/cuidador_model.dart';

import '../../domain/models/typedefs.dart';
import '../../domain/models/usuario/usuario_model.dart';
import '../../domain/repository/cuidador_repo.dart';
import '../../domain/repository/paciente_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';

class CuidadorRepoImpl implements CuidadorRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;
  final PacienteRepo pacienteRepo;

  CuidadorRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
    required this.pacienteRepo,
  });

  final String collection = 'cuidadores';
  final String collectionPacientes = 'pacientes';

  @override
  Future<Result> addCuidador({required String relacion}) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = {
      'usuario_uid': usuarioUid,
      'relacion': await EncryptData.encryptData(relacion),
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
  Future<Result> deleteCuidador() {
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
  Future<Result<CuidadorModel, dynamic>> getCuidador() {
    final currentUser = fireAuthService.currentUser()!;
    return _getCuidadorFirebase(currentUser.uid);
  }

  Future<Success<CuidadorModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(CuidadorModel.fromJson(json));
  }

  @override
  Future<Result> updateCuidador({
    required String relacion,
    List<String>? pacientes,
  }) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = {
      'usuario_uid': usuarioUid,
      'pacientes': jsonEncode(pacientes),
      'relacion': await EncryptData.encryptData(relacion),
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

  @override
  Future<Result<CuidadorModel, dynamic>> findCuidadorByEmail(
    String email,
  ) async {
    try {
      return firebaseService
          .findDocumentByFieldIsEqualToValue(
            collectionPath: collection,
            field: 'email',
            value: email,
          )
          .then((json) => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  @override
  Future<Result<CuidadorModel, dynamic>> findCuidadorByUid(String uidCuidador) {
    return _getCuidadorFirebase(uidCuidador);
  }

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuarioCuidadorByUid(String uid) {
    try {
      return firebaseService
          .getFromDocument(
            collectionPath: collection,
            documentPath: uid,
          )
          .then((json) async => successUsuarioFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error(''));
    }
  }

  Future<Success<UsuarioModel, dynamic>> successUsuarioFromJson(
      Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(UsuarioModel.fromJson(json));
  }

  @override
  Future<void> updateCuidadorRelacion({required String solicitado}) async {
    final currentUser = fireAuthService.currentUser()!;
    final response = await getCuidador();
    final responsePaciente = await pacienteRepo.getPacienteByUid(solicitado);

    CuidadorModel cuidador;
    List<String> pacientes = [];

    responsePaciente.when(
      (success) async {
        await pacienteRepo.addCuidador(
          uidPaciente: success.usuarioUid,
          uidCuidador: currentUser.uid,
        );
      },
      (error) => null,
    );

    response.when(
      (success) {
        cuidador = success;

        if (cuidador.pacientes != null && cuidador.pacientes!.isNotEmpty) {
          pacientes = cuidador.pacientes!;
        }
      },
      (error) => null,
    );

    pacientes.add(solicitado);

    try {
      await firebaseService.updateFieldsOnDocument(
        collectionPath: collection,
        documentPath: currentUser.uid,
        data: {
          'pacientes': jsonEncode(pacientes),
        },
      ).then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<Result<CuidadorModel, dynamic>> _getCuidadorFirebase(String uid) {
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
