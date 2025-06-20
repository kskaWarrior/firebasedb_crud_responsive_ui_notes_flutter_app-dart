import 'package:firebasedb_crud_notes_flutter_app/main.dart';
import 'package:firebasedb_crud_notes_flutter_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  // Instance of FirestoreService to interact with Firestore.

  final TextEditingController titleController = TextEditingController();
  final TextEditingController contentController = TextEditingController();

  void openNoteBox() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                // Add note logic
                firestoreService.addNote(
                  title: titleController.text,
                  content: contentController.text,
                );
                titleController.clear();
                contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void openEditNoteBox(
      String noteId, String currentTitle, String currentContent) {
    titleController.text = currentTitle;
    contentController.text = currentContent;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Note'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: contentController,
                decoration: const InputDecoration(labelText: 'Content'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                firestoreService.updateNote(
                  id: noteId,
                  title: titleController.text,
                  content: contentController.text,
                );
                titleController.clear();
                contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
            TextButton(
              onPressed: () {
                titleController.clear();
                contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentWidth = MediaQuery.of(context).size.width;

    final cardColors = [
      Colors.pink[100],
      Colors.blue[100],
      Colors.green[100],
      Colors.yellow[100],
      Colors.purple[100],
      Colors.orange[100],
      Colors.teal[100],
      Colors.cyan[100],
    ];

    Widget notesListWidget = StreamBuilder(
      stream: firestoreService.getNotes(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              'Error: ${snapshot.error}',
              style: const TextStyle(color: Colors.redAccent),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final notes = snapshot.data?.docs ?? [];
        if (notes.isEmpty) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.sticky_note_2, size: 64, color: Colors.pinkAccent),
                SizedBox(height: 16),
                Text(
                  'No notes yet.\nTap "Add Note" to create one!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18, color: Colors.blueGrey),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          itemCount: notes.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final note = notes[index];
            final cardColor = cardColors[index % cardColors.length];
            return Card(
              color: cardColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 24,
                ),
                title: Text(
                  note['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Colors.black87,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    note['content'],
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.redAccent),
                  onPressed: () {
                    firestoreService.deleteNote(note.id);
                  },
                ),
                onTap: () {
                  openEditNoteBox(note.id, note['title'], note['content']);
                },
              ),
            );
          },
        );
      },
    );

    Widget addNoteForm = Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Add New Note',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
              labelText: 'Content',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            icon: const Icon(Icons.save),
            label: const Text('Save'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              textStyle: const TextStyle(fontSize: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              firestoreService.addNote(
                title: titleController.text,
                content: contentController.text,
              );
              titleController.clear();
              contentController.clear();
              setState(() {}); // Refresh UI
            },
          ),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Firebase CRUD Notes'),
            const SizedBox(width: 12),
            IconButton(
              tooltip: 'Toggle light/dark mode',
              icon: Icon(
                Theme.of(context).brightness == Brightness.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: () {
                themeNotifier.value = themeNotifier.value == ThemeMode.dark
                    ? ThemeMode.light
                    : ThemeMode.dark;
              },
            ),
          ],
        ),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF7F7FD5), Color(0xFF86A8E7), Color(0xFF91EAE4)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        foregroundColor: Colors.white,
      ),
      floatingActionButton: currentWidth <= 700
          ? FloatingActionButton.extended(
              onPressed: openNoteBox,
              icon: const Icon(Icons.add),
              label: const Text('Add Note'),
              backgroundColor: Colors.pinkAccent,
              foregroundColor: Colors.white,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentWidth > 700
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notes list
                  Expanded(
                    flex: 2,
                    child: notesListWidget,
                  ),
                  // Modern vertical separator
                  Container(
                    width: 2,
                    height: 500, // or: double.infinity for full height
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0x3386A8E7),
                          Color(0x3391EAE4),
                        ],
                      ),
                    ),
                  ),
                  // Add note form
                  SizedBox(
                    width: 350,
                    child: addNoteForm,
                  ),
                ],
              )
            : notesListWidget,
      ),
    );
  }
}