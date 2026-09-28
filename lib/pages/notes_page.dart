import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';
import '../widgets/note_card.dart';
import 'add_note_page.dart';
import 'edit_note_page.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> notes = [];

  bool isLoading = false;
  int? deletingId;

  @override
  void initState() {
    super.initState();
    loadNotes();
  }

  Future<void> loadNotes() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final data = await DatabaseHelper.instance.getNotes();

      if (!mounted) {
        return;
      }

      setState(() {
        notes = data;
      });
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memuat catatan'),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> openAddNote() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => const AddNotePage(),
      ),
    );

    if (result == true) {
      await loadNotes();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil disimpan'),
        ),
      );
    }
  }

  Future<void> editNote(Note note) async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => EditNotePage(
          note: note,
        ),
      ),
    );

    if (result == true) {
      await loadNotes();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil diperbarui'),
        ),
      );
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

    if (deletingId != null) {
      return;
    }

    setState(() {
      deletingId = note.id;
    });

    try {
      await DatabaseHelper.instance.deleteNote(note.id!);

      await loadNotes();

      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Catatan berhasil dihapus'),
        ),
      );
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menghapus catatan'),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        deletingId = null;
      });
    }
  }

  Widget buildBody() {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notes.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.note_alt_outlined,
                size: 64,
              ),
              const SizedBox(height: 12),
              const Text(
                'Belum ada catatan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Buat catatan pertama Anda.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: openAddNote,
                icon: const Icon(Icons.add),
                label: const Text('Tambah Catatan'),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];

        return NoteCard(
          note: note,
          isDeleting: deletingId == note.id,
          onEdit: () => editNote(note),
          onDelete: () => deleteNote(note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        centerTitle: false,
      ),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: isLoading ? null : openAddNote,
        tooltip: 'Tambah catatan',
        child: const Icon(Icons.add),
      ),
    );
  }
}