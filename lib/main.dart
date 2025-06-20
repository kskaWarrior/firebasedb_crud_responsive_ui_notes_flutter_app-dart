import 'package:firebase_core/firebase_core.dart';
import 'package:firebasedb_crud_notes_flutter_app/firebase_options.dart';
import 'package:firebasedb_crud_notes_flutter_app/pages/home_page.dart';
import 'package:flutter/material.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Ensure that the Flutter engine is initialized before running the app.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // Initialize Firebase with the default options for the current platform.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Firebase CRUD Notes',
          theme: ThemeData(
            brightness: Brightness.light,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: Colors.grey[100],
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.black87,
              elevation: 2,
            ),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
          ),
          darkTheme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            scaffoldBackgroundColor: const Color(0xFF181A20),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              elevation: 2,
            ),
            cardColor: const Color(0xFF23262F),
            dialogBackgroundColor: const Color(0xFF23262F),
            floatingActionButtonTheme: const FloatingActionButtonThemeData(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color(0xFF23262F),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white24),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          themeMode: mode,
          home: const HomePage(),
        );
      },
    );
  }
}
