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

}