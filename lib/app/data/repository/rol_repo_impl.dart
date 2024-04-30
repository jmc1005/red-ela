import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/rol/rol_model.dart';
import '../../domain/models/typedefs.dart';
import '../../domain/repository/rol_repo.dart';
import '../firebase/firebase_service.dart';

class RolRepoImpl implements RolRepo {
  final FirebaseService firebaseService;

  RolRepoImpl({
    required this.firebaseService,
  });

  final String collection = 'roles';

  @override
  Future<Result> addRol(String rol, String descripcion) {
    final data = {
      'rol': rol,
      'descripcion': descripcion,
    };

    return firebaseService
        .setDataOnDocument(
          collectionPath: collection,
          documentPath: rol,
          data: data,
        )
        .then((value) => const Success('data-added'))
        .catchError((error) => const Error('data-add-failed'));
  }

  @override
  Future<Result<RolModel, dynamic>> getRol(String rol) {
    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: rol,
        )
        .then((json) => Success(RolModel.fromJson(json)))
        .catchError((onError) => Error('data-get-failed'));
  }

  @override
  Future<Result> updateRol(String uuid, String rol, String descripcion) {
    return firebaseService
        .updateDataOnDocument(collectionPath: collection, uuid: uuid, data: {
          'rol': rol,
          'descripcion': descripcion,
        })
        .then((json) => const Success('data-updated'))
        .catchError((onError) => const Error('data-update-failed'));
  }

  @override
  Future<Result<dynamic, dynamic>> deleteRol(String rol) async {
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
        .then((value) => const Success('data-deleted'))
        .catchError((error) => const Error('data-delete-failed'));
  }
}
