import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/cuidador/cuidador_model.dart';
import '../../domain/models/paciente/paciente_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/paciente_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';

class PacienteRepoImpl implements PacienteRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  PacienteRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'pacientes';

  @override
  Future<Result> addPaciente(String tratamiento, String fechaDiagnostico,
      String inicio, CuidadorModel cuidador) async {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
    );

    return firebaseService
        .setDataOnDocument(
          collectionPath: collection,
          documentPath: usuarioUid,
          data: data,
        )
        .then((value) => const Success('data-added'))
        .catchError((error) => const Error('data-add-failed'));
  }

  @override
  Future<Result> updatePaciente(
    String tratamiento,
    String fechaDiagnostico,
    String inicio,
    CuidadorModel cuidador,
  ) {
    final usuarioUid = fireAuthService.currentUser()!.uid;

    final data = getDataPaciente(
      usuarioUid,
      tratamiento,
      fechaDiagnostico,
      inicio,
      cuidador,
    );

    return firebaseService
        .updateDataOnDocument(
          collectionPath: collection,
          uuid: usuarioUid,
          data: data,
        )
        .then((value) => const Success('data-updated'))
        .catchError((error) => const Error('data-update-failed'));
  }

  @override
  Future<Result> deletePaciente() {
    final currentUser = fireAuthService.currentUser()!;

    return firebaseService
        .deleteDocumentFromCollection(
          collectionPath: collection,
          uid: currentUser.uid,
        )
        .then((value) => const Success('data-deleted'))
        .catchError((error) => const Error('data-delete-failed'));
  }

  @override
  Future<Result<PacienteModel, dynamic>> getPaciente() {
    final currentUser = fireAuthService.currentUser();

    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: currentUser!.uid,
        )
        .then((json) => Success(PacienteModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
  }

  Json getDataPaciente(
    String usuarioUid,
    String tratamiento,
    String fechaDiagnostico,
    String inicio,
    CuidadorModel cuidador,
  ) {
    final data = {
      'usuario_uid': usuarioUid,
      'tratamiento': tratamiento,
      'fecha_diagnostico': fechaDiagnostico,
      'inicio': inicio,
    };

    if (cuidador.usuarioUid != null && cuidador.usuarioUid!.isNotEmpty) {
      data['cuidador'] = jsonEncode(
        {'usuario_uid': cuidador.usuarioUid!},
      );
    } else {
      data['cuidador'] = jsonEncode(
        {
          'nombre': cuidador.nombre,
          'apellido1': cuidador.apellido1,
          'apellido2': cuidador.apellido2,
          'email': cuidador.email,
          'telefono': cuidador.telefono,
          'relacion': cuidador.relacion,
        },
      );
    }

    return data;
  }

  @override
  Future<Result<List<String>, dynamic>> getAllPacientesByUidOrEmailCuidador(
    String uidCuidador,
    String email,
  ) async {
    final filterCuidadorUid = Filter(
      'cuidador.usuario_uid',
      isEqualTo: uidCuidador,
    );

    final filterCuidadorEmail = Filter(
      'cuidador.email',
      isEqualTo: email,
    );

    final data = await firebaseService
        .getCollection(collectionPath: collection)
        .where(Filter.or(filterCuidadorUid, filterCuidadorEmail))
        .get();

    final List<String> dataList = data.docs
        .map(
          (e) => PacienteModel.fromJson(e.data()).usuarioUid,
        )
        .toList();

    return Future.value(Success(dataList));
  }
}
