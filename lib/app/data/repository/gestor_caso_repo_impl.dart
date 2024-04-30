import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/gestor_casos/gestor_casos_model.dart';
import '../../domain/repository/gestor_casos_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';

class GestorCasosRepoImpl implements GestorCasosRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  GestorCasosRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'gestores_casos';

  @override
  Future<Result> addGestorCasos(String hospital) {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'hospital': hospital,
    };

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
  Future<Result> deleteGestorCasos() {
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
  Future<Result<GestorCasosModel, dynamic>> getGestorCasos() {
    final currentUser = fireAuthService.currentUser();

    return firebaseService
        .getFromDocument(
          collectionPath: collection,
          documentPath: currentUser!.uid,
        )
        .then((json) => Success(GestorCasosModel.fromJson(json)))
        .catchError((onError) => const Error('data-get-failed'));
  }

  @override
  Future<Result> updateGestorCasos(String hospital) {
    final usuarioUid = fireAuthService.currentUser()!.uid;
    final data = {
      'hospital': hospital,
    };

    return firebaseService
        .updateDataOnDocument(
          collectionPath: collection,
          uuid: usuarioUid,
          data: data,
        )
        .then((value) => const Success('data-updated'))
        .catchError((error) => const Error('data-update-failed'));
  }
}
