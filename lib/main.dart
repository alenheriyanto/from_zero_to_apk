import 'package:flutter/material.dart';

import 'add_note_page.dart';
import 'database/database_helper.dart';
import 'edit_note_page.dart';
import 'models/note.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Notes',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    final data = await DatabaseHelper.instance.getNotes();

    if (!mounted) {
      return;
    }

    setState(() {
      notes = data;
    });
  }

  Future<void> openAddNote() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => const AddNotePage(),
      ),
    );

    if (result == true) {
      await loadNotes();
    }
  }

  Future<void> editNote(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (context) => EditNotePage(
          note: note,
        ),
      ),
    );

    if (result == true) {
      await loadNotes();
    }
  }

  Future<void> deleteNote(Note note) async {
    final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Hapus catatan?'),
              content: Text(
                'Hapus "${note.title}"?',
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Batal'),
                ),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Hapus'),
                ),
              ],
            );
          },
        ) ??
        false;

    if (!confirmed) {
      return;
    }

    await DatabaseHelper.instance.deleteNote(note.id!);

    await loadNotes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: notes.isEmpty
          ? const Center(
              child: Text('Belum ada catatan'),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];

                return Card(
                  margin: const EdgeInsets.only(
                    bottom: 12,
                  ),
                  child: ListTile(
                    leading: const Icon(
                      Icons.note,
                    ),
                    title: Text(
                      note.title,
                    ),
                    subtitle: Text(
                      note.content,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            editNote(note);
                          },
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                          ),
                          onPressed: () {
                            deleteNote(note);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: openAddNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}