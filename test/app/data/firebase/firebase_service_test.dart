import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:red_ela/app/data/firebase/firebase_service.dart';
import 'package:red_ela/app/domain/models/typedefs.dart';

import '../../../utils/map_list_contains.dart';

void main() {
  group('Firebase Service', () {
    FirebaseService? firebaseService;
    FakeFirebaseFirestore? fakeFirebaseFirestore;
    const Json data = {'data': '42'};

    setUp(() {
      fakeFirebaseFirestore = FakeFirebaseFirestore();
    });

    group('Collection Operations', () {
      test('addToCollection', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        await firebaseService?.addToCollection(
          data: data,
          collectionPath: collectionPath,
        );

        final List<Json> actualDataList =
            (await fakeFirebaseFirestore!.collection('collectionPath').get())
                .docs
                .map((e) => e.data())
                .toList();

        expect(actualDataList, MapListContains(null, data));
      });

      test('getCollection', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        final collectionReference = firebaseService?.getCollection(
          collection: collectionPath,
        );

        expect(collectionReference != null, true);
      });

      test('getDocumentFromCollection', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        final ref = firebaseService?.getDocumentFromCollection(
          collection: collectionPath,
          document: 'document',
        );

        expect(ref != null, true);
      });

      test('getFromCollection', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        final list = await firebaseService?.getFromCollection(
          collectionPath: collectionPath,
        );

        expect(list != null, true);
      });
    });

    group('Document Operations', () {
      test('setDataOnDocument', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        await firebaseService?.setDataOnDocument(
          collection: collectionPath,
          document: 'document',
          data: data,
        );

        final List<Json> actualDataList =
            (await fakeFirebaseFirestore!.collection('collectionPath').get())
                .docs
                .map((e) => e.data())
                .toList();

        expect(actualDataList, MapListContains(null, data));
      });

      test('getFromDocument', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        final json = await firebaseService?.getFromDocument(
          collection: collectionPath,
          document: 'document',
        );

        expect(json != null, true);
      });

      test('updateDataOnDocument', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        await firebaseService?.setDataOnDocument(
          collection: collectionPath,
          document: 'document',
          data: data,
        );

        final newData = {'data': '44'};

        await firebaseService?.updateDataOnDocument(
          collection: collectionPath,
          document: 'document',
          data: newData,
        );

        final actual = await fakeFirebaseFirestore!
            .collection(collectionPath)
            .doc('document')
            .get();

        expect(actual.data(), newData);
      });

      test('deleteDocumentFromCollection', () async {
        firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

        const String collectionPath = 'collectionPath';

        await firebaseService?.setDataOnDocument(
          collection: collectionPath,
          document: 'document',
          data: data,
        );

        await firebaseService?.deleteDocumentFromCollection(
          collectionPath: collectionPath,
          uid: 'document',
        );

        final actual = await fakeFirebaseFirestore!
            .collection(collectionPath)
            .doc('document')
            .get();

        expect(actual.exists, false);
      });
    });

    test('updateFieldsOnDocument', () async {
      firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

      const String collectionPath = 'collectionPath';

      await firebaseService?.setDataOnDocument(
        collection: collectionPath,
        document: 'document',
        data: data,
      );

      final newData = {'data': '44', 'prueba': 2};

      await firebaseService?.updateFieldsOnDocument(
        collection: collectionPath,
        document: 'document',
        data: newData,
      );

      final actual = await fakeFirebaseFirestore!
          .collection(collectionPath)
          .doc('document')
          .get();

      expect(actual.data(), newData);
    });

    test('findDocumentByFieldIsEqualToValue', () async {
      firebaseService = FirebaseService(firestore: fakeFirebaseFirestore!);

      const String collectionPath = 'collectionPath';

      await firebaseService?.setDataOnDocument(
        collection: collectionPath,
        document: 'document',
        data: data,
      );

      final json = await firebaseService?.findDocumentByFieldIsEqualToValue(
        collectionPath: collectionPath,
        field: 'data',
        value: '42',
      );

      final actual = await fakeFirebaseFirestore!
          .collection(collectionPath)
          .where('data', isEqualTo: '42')
          .get();

      expect(actual.docs[0].data(), json);
    });
  });
}
