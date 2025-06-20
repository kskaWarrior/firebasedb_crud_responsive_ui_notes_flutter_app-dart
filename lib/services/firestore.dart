import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference notes = FirebaseFirestore.instance.collection('notes');

  Future<void> addNote({
    required String title,
    required String content,
  }) async {
    await notes.add({
      'title': title,
      'content': content,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    await notes.doc(id).update({
      'title': title,
      'content': content,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteNote(String id) async {
    await notes.doc(id).delete();
  }

  Stream<QuerySnapshot> getNotes() {
    return notes.orderBy('createdAt', descending: true).snapshots();
  }
}