// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

currentDate() => DateTime.now();
idFromCurrentDate() => currentDate().toString();

typedef BatchWriteHandler<T> = Future<void> Function(WriteBatch batch);
typedef TransactionBuilder<T> = void Function(
    QuerySnapshot<Object?> snapshots, Transaction transaction);

class FirestoreService {
  FirestoreService({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;
  final FirebaseFirestore _firestore;

  Future<void> setData({
    required String path,
    required Map<String, dynamic> data,
    bool merge = true,
  }) async {
    final db = _firestore.doc(path);
    await Future.delayed(const Duration(milliseconds: 1000));
    await db.set(data, SetOptions(merge: merge));
  }

  Future<void> updateDoc(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = _firestore.doc(path);
    await Future.delayed(const Duration(milliseconds: 1000));
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final db = _firestore.doc(path);
    await Future.delayed(const Duration(milliseconds: 1000));
    await db.delete();
  }

  DocumentReference docRef({required String docPath}) =>
      _firestore.doc(docPath);
  Future<void> batchWrite({required BatchWriteHandler batchHandler}) =>
      batchHandler(_firestore.batch());

  Future<List<T>> fetchCollection<T>(
      {required String path,
      required T Function(Map<String, dynamic> data) builder,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    final snapshots = query.get();
    return snapshots.then((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>))
          .where((value) => value != null)
          .toList();
      if (sort != null) {
        result.sort(sort);
      }
      return result;
    });
  }

  //* transaction is automatically returned
  Future<void> collectionTransaction({
    required String collectionPath,
    required TransactionBuilder transactionBuilder,
    Query Function(Query? query)? queryBuilder,
  }) =>
      _firestore.runTransaction((transaction) async {
        Query query = _firestore.collection(collectionPath);
        if (queryBuilder != null) {
          query = queryBuilder(query);
        }
        final snapshots = await query.get();
        transactionBuilder(snapshots, transaction);
      });

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic>) builder,
    Query Function(Query? query)? queryBuilder,
  }) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }

    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>))
          .where((element) => element != null)
          .toList();
      return result;
    });
  }

  Stream<T> documentStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>? data) builder}) {
    final reference = _firestore.doc(path);

    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => builder(snapshot.data()));
  }

  Future<T> getDocument<T>(
      {required String path,
      required T Function(Map<String, dynamic> data) builder}) async {
    final reference = _firestore.doc(path);
    final snapshot = reference.get();
    return snapshot
        .then((snapshot) => builder(snapshot.data() as Map<String, dynamic>));
  }

  ///add more methods that you need here...
}

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firestoreServiceProvider = Provider<FirestoreService>(
    (ref) => FirestoreService(firestore: ref.watch(firebaseFirestoreProvider)));
