import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../domain/models/typedefs.dart';

class FirebaseService {
  final FirebaseFirestore firestore;

  FirebaseService({required this.firestore});

  /// Collection Operations

  Future<DocumentReference<Json>> addToCollection({
    required String collectionPath,
    required Json data,
  }) async {
    return getCollection(
      collection: collectionPath,
    ).add(data);
  }

  CollectionReference<Json> getCollection({
    required String collection,
  }) {
    return firestore.collection(collection);
  }

  DocumentReference<Json> getDocumentFromCollection({
    required String collection,
    required String document,
  }) {
    return firestore.collection(collection).doc(document);
  }

  Future<List<Json>> getFromCollection({
    required String collectionPath,
  }) async {
    final collection = await getCollection(
      collection: collectionPath,
    ).get();

    final List<Json> dataList = collection.docs.map((e) => e.data()).toList();

    return Future.value(dataList);
  }

  Stream<QuerySnapshot<Json>> getSnapshotStreamFromCollection({
    required String collection,
  }) {
    return getCollection(
      collection: collection,
    ).snapshots();
  }

  /// Document Operations

  Future<void> setDataOnDocument({
    required String collection,
    required String document,
    required Json data,
  }) {
    return getCollection(collection: collection).doc(document).set(data);
  }

  Future<Json> getFromDocument({
    required String collection,
    required String document,
  }) async {
    debugPrint('obtener colección $collection documento $document');
    final data = await getCollection(
      collection: collection,
    ).doc(document).get();

    return Future.value(data.data());
  }

  Future<void> updateDataOnDocument({
    required String collection,
    required String document,
    required Json data,
  }) {
    debugPrint(
      'actualizar colección $collection documento $document datos $data',
    );
    return getCollection(collection: collection).doc(document).update(data);
  }

  Future<void> deleteDocumentFromCollection({
    required String collectionPath,
    required String uid,
  }) {
    return getCollection(collection: collectionPath).doc(uid).delete();
  }

  Future<Json> findDocumentByFieldIsEqualToValue(
      {required String collectionPath,
      required String field,
      required String value}) async {
    final data = await getCollection(collection: collectionPath)
        .where(field, isEqualTo: value)
        .get();

    return Future.value(data.docs[0].data());
  }

  Future<void> updateFieldsOnDocument({
    required String collection,
    required String document,
    required Json data,
  }) async {
    debugPrint(
      'actualizar colección $collection documento $document datos $data',
    );
    return getCollection(
      collection: collection,
    ).doc(document).set(
          data,
          SetOptions(merge: true),
        );
  }
}
