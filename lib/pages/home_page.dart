import 'package:flutter/material.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase CRUD Notes Flutter App Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Firebase CRUD Notes'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Action to add a new note
          },
          child: const Icon(Icons.add),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}