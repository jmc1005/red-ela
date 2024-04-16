import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: unused_import
import 'package:uuid/uuid.dart';

import '../../domain/models/typedefs.dart';

class FirebaseService {
  final FirebaseFirestore firestore;

  FirebaseService({required this.firestore});

  /// Collection Operations

  Future<Json> addToCollection({
    required Json data,
    required String collectionPath,
  }) async {
    late final Json json;

    firestore
        .collection(collectionPath)
        .add(data)
        .whenComplete(() => json = {'success': 'success'})
        .catchError((e) => json = {'error': e});

    return Future.value(json);
  }

  Future<List<Json>> getFromCollection({
    required String collectionPath,
  }) async {
    final collection = await firestore.collection(collectionPath).get();

    final List<Json> dataList = collection.docs.map((e) => e.data()).toList();

    return Future.value(dataList);
  }

  Stream<QuerySnapshot<Json>> getSnapshotStreamFromCollection({
    required String collectionPath,
  }) {
    return firestore.collection(collectionPath).snapshots();
  }

  /// Document Operations

  Future<Json> setDataOnDocument({
    required String collection,
    required String documentPath,
    required Json data,
  }) async {
    late final Json json;

    await firestore
        .collection(collection)
        .doc(documentPath)
        .set(data)
        .whenComplete(() => json = {'success': 'success'})
        .catchError((e) => json = {'error': e});

    return Future.value(json);
  }

  Future<Json> getFromDocument({
    required String collectionPath,
    required String documentPath,
  }) async {
    final data = await firestore
        .collection(
          collectionPath,
        )
        .doc(
          documentPath,
        )
        .get();

    log('$data');

    return Future.value(data.data());
  }

  Future<Json> updateDataOnDocument({
    required String collection,
    required String uuid,
    required Json data,
  }) async {
    late final Json json;

    await firestore
        .collection(collection)
        .doc(uuid)
        .update(data)
        .whenComplete(() => json = {'success': 'success'})
        .catchError((e) => json = {'error': e});

    return Future.value(json);
  }

  Future<Json> deleteDocumentFromCollection({
    required String collection,
    required String uuid,
    required Json data,
  }) async {
    late final Json json;

    await firestore
        .collection(collection)
        .doc(uuid)
        .delete()
        .whenComplete(() => json = {'success': 'success'})
        .catchError((e) => json = {'error': e});

    return Future.value(json);
  }
}
