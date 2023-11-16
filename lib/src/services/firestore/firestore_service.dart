// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

DateTime currentDate() => DateTime.now();
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
    // await Future.delayed(const Duration(milliseconds: 1000));
    await db.set(data, SetOptions(merge: merge));
  }

  Future<void> updateDoc(
      {required String path, required Map<String, dynamic> data}) async {
    final reference = _firestore.doc(path);
    // await Future.delayed(const Duration(milliseconds: 1000));
    await reference.update(data);
  }

  Future<void> deleteData({required String path}) async {
    final db = _firestore.doc(path);
    // await Future.delayed(const Duration(milliseconds: 1000));
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
    final snapshots = _getQuery(path, queryBuilder).get();
    return snapshots.then((snapshot) {
      final results = _getList(snapshot.docs, builder, sort);
      return results;
    });
  }

  Future<(List<T>, DocumentSnapshot?)> fetchPaginatedData<T>(
      {required String path,
      required T Function(Map<String, dynamic> data) builder,
      List<T>? currentList,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) async {
    final snapshots = await _getQuery(path, queryBuilder).get();

    return _getListAndLastDoc(snapshots, builder, currentList, sort);
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

  Stream<List<T>> collectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>) builder,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    final snapshots = _getQuery(path, queryBuilder).snapshots();
    return snapshots.map((snapshot) {
      return _getList(snapshot.docs, builder, sort);
    });
  }

  Stream<(List<T>, DocumentSnapshot?)> paginatedCollectionStream<T>(
      {required String path,
      required T Function(Map<String, dynamic>) builder,
      List<T>? currentList,
      Query Function(Query? query)? queryBuilder,
      int Function(T lhs, T rhs)? sort}) {
    final snapshots = _getQuery(path, queryBuilder).snapshots();
    return snapshots.map(
        (snapshot) => _getListAndLastDoc(snapshot, builder, currentList, sort));
  }

  Query<T> collectionQuery<T>({
    required String path,
    required T Function(DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options)
        fromMap,
    required Map<String, Object?> Function(T, SetOptions? options) toMap,
    Query<T> Function(Query<T>? query)? queryBuilder,
  }) {
    Query<T> query = _firestore
        .collection(path)
        .withConverter<T>(fromFirestore: fromMap, toFirestore: toMap);
    if (queryBuilder != null) {
      return query = queryBuilder(query);
    } else {
      return query;
    }
  }

  (List<T>, DocumentSnapshot?) _getListAndLastDoc<T>(
      QuerySnapshot snapshot,
      T Function(Map<String, dynamic>) builder,
      List<T>? currentList,
      int Function(T lhs, T rhs)? sort) {
    if (snapshot.docs.isEmpty) return ({...?currentList}.toList(), null);

    _getList(snapshot.docs, builder, sort).map((e) {});

    final list =
        {...?currentList, ..._getList(snapshot.docs, builder, sort)}.toList();
    return (list, snapshot.docs.last);
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

  Query _getQuery(String path, Query Function(Query? query)? queryBuilder) {
    Query query = _firestore.collection(path);
    if (queryBuilder != null) {
      query = queryBuilder(query);
    }
    return query;
  }

  List<T> _getList<T>(
      List<QueryDocumentSnapshot> docs,
      T Function(Map<String, dynamic>) builder,
      int Function(T lhs, T rhs)? sort) {
    if (docs.isEmpty) return [];
    final result = docs
        .map((snapshot) => builder(snapshot.data() as Map<String, dynamic>))
        .where((element) => element != null)
        .toList();
    if (sort != null) {
      result.sort(sort);
    }
    return result;
  }

  ///add more methods that you need here...
}

final firebaseFirestoreProvider =
    Provider<FirebaseFirestore>((ref) => FirebaseFirestore.instance);
final firestoreServiceProvider = Provider<FirestoreService>(
    (ref) => FirestoreService(firestore: ref.watch(firebaseFirestoreProvider)));
