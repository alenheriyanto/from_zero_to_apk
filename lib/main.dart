import 'package:flutter/material.dart';
import 'add_note_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
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
  final List<Map<String, String>> notes = [];

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
                  child: ListTile(
                    leading: const Icon(Icons.note),
                    title: Text(note['title']!),
                    subtitle: Text(note['content']!),
                  ),
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push<Map<String, String>>(
            context,
            MaterialPageRoute(
              builder: (context) => const AddNotePage(),
            ),
          );

          if (result != null) {
            setState(() {
              notes.add(result);
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}