import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FiresotreServices {
  FiresotreServices._();

  static final instance = FiresotreServices._();

  Future<void> setData({@required String path, @required Map<String, dynamic> data}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('$path :$data');
    await reference.set(data);
  }

  Future<void> deleteData({@required String path}) async {
    final reference = FirebaseFirestore.instance.doc(path);
    print('job deleted from firestore successfully :$path');
    await reference.delete();
  }

  Stream<List<T>> collectionStream<T>({
    @required String path,
    @required T Function(Map<String, dynamic> data, String documentId) builder,
  }) {
    final reference = FirebaseFirestore.instance.collection(path);
    final snapshots = reference.snapshots();
    return snapshots.map((snapshot) => snapshot.docs
        .map((snapshot) => builder(snapshot.data(), snapshot.id))
        .toList());
  }
}
