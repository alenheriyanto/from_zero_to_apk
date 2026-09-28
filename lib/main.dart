import 'package:flutter/material.dart';

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

class NotesPage extends StatelessWidget {
  const NotesPage({super.key});

  final notes = const [
    {
      'title': 'Belajar Flutter',
      'content': 'Memahami widget dasar',
    },
    {
      'title': 'Belajar SQLite',
      'content': 'Menyimpan data lokal',
    },
    {
      'title': 'Project My Notes',
      'content': 'Membangun aplikasi notes dengan Flutter',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.note),
              title: Text(notes[0]['title']!),
              subtitle: Text(notes[0]['content']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage),
              title: Text(notes[1]['title']!),
              subtitle: Text(notes[1]['content']!),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb),
              title: Text(notes[2]['title']!),
              subtitle: Text(notes[2]['content']!),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Akan digunakan pada Modul 04.
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}