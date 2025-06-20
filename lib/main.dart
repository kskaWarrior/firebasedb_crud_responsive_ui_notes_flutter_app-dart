import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedb_crud_notes_flutter_app/firebase_options.dart';
import 'package:firebasedb_crud_notes_flutter_app/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that the Flutter engine is initialized before running the app.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Firebase with the default options for the current platform.
  runApp(const MyApp());
}