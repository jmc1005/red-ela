import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/typedefs.dart';

class FirebaseService {
  final FirebaseFirestore firestore;

  FirebaseService({required this.firestore});

  /// Collection Operations

  Future<DocumentReference<Json>> addToCollection({
    required String collectionPath,
    required Json data,
  }) async {
    return firestore.collection(collectionPath).add(data);
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

  Future<void> setDataOnDocument({
    required String collectionPath,
    required String documentPath,
    required Json data,
  }) async {
    return firestore.collection(collectionPath).doc(documentPath).set(data);
  }

  Future<Json> getFromDocument({
    required String collectionPath,
    required String documentPath,
  }) async {
    final data =
        await firestore.collection(collectionPath).doc(documentPath).get();

    return Future.value(data.data());
  }

  Future<void> updateDataOnDocument({
    required String collectionPath,
    required String uuid,
    required Json data,
  }) async {
    return firestore.collection(collectionPath).doc(uuid).update(data);
  }

  Future<void> deleteDocumentFromCollection({
    required String collectionPath,
    required String uid,
  }) async {
    return firestore.collection(collectionPath).doc(uid).delete();
  }
}
