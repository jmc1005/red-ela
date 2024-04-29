import 'package:multiple_result/multiple_result.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/rol/rol_model.dart';
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
    const uuid = Uuid();
    final uuidDoc = uuid.v1();

    final data = {
      'rol': rol,
      'descripcion': descripcion,
    };

    return firebaseService
        .setDataOnDocument(
          collectionPath: collection,
          documentPath: uuidDoc,
          data: data,
        )
        .then((value) => const Success('data-added'))
        .catchError((error) => const Error('data-add-failed'));
  }

  @override
  Future<Result<RolModel, dynamic>> getRol(String uuid) {
    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: uuid,
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
}
