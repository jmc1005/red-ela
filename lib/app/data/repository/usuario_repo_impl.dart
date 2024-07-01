import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:multiple_result/multiple_result.dart';

import '../../domain/models/typedefs.dart';
import '../../domain/models/usuario/usuario_model.dart';
import '../../domain/repository/usuario_repo.dart';
import '../firebase/fireauth_service.dart';
import '../firebase/firebase_service.dart';
import '../services/local/encrypt_data.dart';
import '../services/local/preferencias_usuario.dart';

class UsuarioRepoImpl extends UsuarioRepo {
  final FireAuthService fireAuthService;
  final FirebaseService firebaseService;

  UsuarioRepoImpl({
    required this.fireAuthService,
    required this.firebaseService,
  });

  final String collection = 'usuarios';
  final String urlLinkSingUp = '/accounts:signUp';
  final prefs = PreferenciasService();

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuario() async {
    try {
      final usuarioUid = fireAuthService.currentUser()!.uid;

      return firebaseService
          .getFromDocument(collection: collection, document: usuarioUid)
          .then(
        (json) async {
          final rol = json['rol'];
          final rolDecrypt = await EncryptData.decryptData(rol);

          if (rolDecrypt != null) {
            prefs.rol = rolDecrypt;
          }
          return successFromJson(json);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  @override
  Future<Result<UsuarioModel, dynamic>> getUsuarioByUid(
      {required String uid}) async {
    try {
      return await firebaseService
          .getFromDocument(
            collection: collection,
            document: uid,
          )
          .then((json) => successFromJson(json));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<Success<UsuarioModel, dynamic>> successFromJson(Json json) async {
    json = await EncryptData.decryptDataJson(json);
    return Success(UsuarioModel.fromJson(json));
  }

  @override
  Future<bool> get isSignedIn async => fireAuthService.currentUser() != null;

  @override
  Future<Result<User, dynamic>> signIn(String email, String password) async {
    final result = await fireAuthService.signInWithEmailAndPassword(
      email,
      password,
    );

    if (result is User) {
      prefs.currentUid = result.uid;

      addDeviceToken(result.uid);
      return Success(result);
    }

    return Error(result);
  }

  @override
  Future<void> signOut() async {
    await fireAuthService.signOut();
  }

  @override
  Future<Result<dynamic, dynamic>> signUp(
    String email,
    String password,
    String rol,
  ) async {
    final result = await fireAuthService.createUserWithEmailAndPassword(
      email,
      password,
    );

    if (result is User) {
      final resultAdd = await addUsuario(email: email, rol: rol);

      return resultAdd.when(
        (success) => Success(success),
        (error) => Error(error),
      );
    }

    return Error(result);
  }

  @override
  Future<Result<dynamic, dynamic>> updateUsuario({
    required String uid,
    required String nombre,
    required String apellido1,
    required String apellido2,
    required String email,
    String? password,
    required String telefono,
    required String fechaNacimiento,
    required String rol,
  }) async {
    try {
      final nombreEncrypt = await EncryptData.encryptData(nombre);
      final apellido1Encrypt = await EncryptData.encryptData(apellido1);
      final apellido2Encrypt = await EncryptData.encryptData(apellido2);
      final nombreCompleto = '$nombre $apellido1 $apellido2';
      final currentUser = fireAuthService.currentUser()!;

      final data = {
        'uid': uid,
        'nombre': nombreEncrypt,
        'apellido1': apellido1Encrypt,
        'apellido2': apellido2Encrypt,
        'nombre_completo': await EncryptData.encryptData(nombreCompleto),
        'email': email,
        'fecha_nacimiento': await EncryptData.encryptData(fechaNacimiento),
        'telefono': telefono,
        'rol': await EncryptData.encryptData(rol),
      };

      if (uid == '' && currentUser.email == null && password != null) {
        await linkSignUp(email, password);
        final nuevoUid = fireAuthService.currentUser()!.uid;

        data['uid'] = nuevoUid;
        return firebaseService
            .setDataOnDocument(
          collection: collection,
          document: nuevoUid,
          data: data,
        )
            .then((value) async {
          await addDeviceToken(nuevoUid);
          return const Success('data-updated');
        });
      } else {
        return firebaseService
            .updateDataOnDocument(
          collection: collection,
          document: uid,
          data: data,
        )
            .then((value) async {
          await addDeviceToken(uid);
          return const Success('data-updated');
        });
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-update-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> addUsuario({
    String? email,
    String? phoneNumber,
    required String rol,
  }) async {
    final currentUser = fireAuthService.currentUser()!;

    final data = {
      'uid': currentUser.uid,
      'nombre_completo': '',
      'email': email ?? '',
      'rol': await EncryptData.encryptData(rol),
      'telefono': phoneNumber != null ? phoneNumber.replaceAll('+34', '') : '',
    };

    try {
      return firebaseService
          .setDataOnDocument(
            collection: collection,
            document: currentUser.uid,
            data: data,
          )
          .then((value) => const Success('data-added'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-add-failed'));
    }
  }

  @override
  Future<Result<dynamic, dynamic>> deleteUsuario() async {
    final currentUser = fireAuthService.currentUser()!;

    try {
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: currentUser.uid,
          )
          .then((value) => borrarUsuarioAuth());
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  Future<Result<dynamic, dynamic>> borrarUsuarioAuth() {
    try {
      return fireAuthService
          .delete()
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }

  @override
  Future<Result<List<UsuarioModel>, dynamic>> getAllUsuario() async {
    final List<UsuarioModel> list = [];
    try {
      final usuarios = await firebaseService.getFromCollection(
        collectionPath: collection,
      );

      for (final element in usuarios) {
        final json = await EncryptData.decryptDataJson(element);
        list.add(UsuarioModel.fromJson(json));
      }

      return Success(list);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return const Error('data-get-failed');
    }
  }

  @override
  Future<Result<dynamic, dynamic>> signUpPhoneNumber({
    required String rol,
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      prefs.verificationId = verificationId;
      prefs.smsCode = smsCode;
      prefs.rol = rol;

      final result = await fireAuthService.phoneCredential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      if (result is User) {
        return const Success('data-added');
      }
    } on FirebaseAuthException catch (e) {
      return Error(e.code);
    }

    return const Error('user-not-found');
  }

  @override
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required String rol,
    required String solicitado,
    required BuildContext context,
  }) async {
    await fireAuthService.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      rol: rol,
      solicitado: solicitado,
      context: context,
    );
  }

  @override
  Future<void> resetPassword({required String email}) async {
    fireAuthService.resetPassword(email: email);
  }

  @override
  Future<Result<UsuarioModel, dynamic>> findUsuarioByTelefonoOrEmail({
    required String telefono,
    String? email,
  }) async {
    try {
      if (email == null) {
        return firebaseService
            .findDocumentByFieldIsEqualToValue(
              collectionPath: collection,
              field: 'telefono',
              value: telefono,
            )
            .then((json) => successFromJson(json));
      } else {
        final filterTelefono = Filter('telefono', isEqualTo: telefono);
        final filterEmail = Filter('email', isEqualTo: email);

        final query = await firebaseService
            .getCollection(
              collection: collection,
            )
            .where(Filter.or(filterTelefono, filterEmail))
            .get();

        final json = query.docs.first.data();

        return successFromJson(json);
      }
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-get-failed'));
    }
  }

  Future<void> linkSignUp(
    String email,
    String password,
  ) async {
    final currentUser = fireAuthService.currentUser()!;
    currentUser.delete();

    final verificationId = prefs.verificationId;
    final smsCode = prefs.smsCode;

    final credential =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    final phoneCredential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await credential.user!.updatePhoneNumber(phoneCredential);
  }

  Future<void> addDeviceToken(String uid) async {
    final prefs = PreferenciasService();

    debugPrint('token ${prefs.token}');

    final docRef = firebaseService.getDocumentFromCollection(
        collection: collection, document: uid);

    if (prefs.token.isNotEmpty) {
      docRef.get().then(
        (d) async {
          if (d.exists) {
            await docRef.update({
              'token': FieldValue.arrayUnion([prefs.token])
            });
          }
        },
      );
    }
  }

  @override
  Future<Result> deleteUsuarioByUid({required String uid}) {
    try {
      return firebaseService
          .deleteDocumentFromCollection(
            collectionPath: collection,
            uid: uid,
          )
          .then((value) => const Success('data-deleted'));
    } catch (e) {
      debugPrint(e.toString());
      return Future.value(const Error('data-delete-failed'));
    }
  }
}
