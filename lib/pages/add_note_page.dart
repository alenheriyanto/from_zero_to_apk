import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  bool isSaving = false;

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveNote() async {
    if (isSaving) {
      return;
    }

    final title = titleController.text.trim();
    final content = contentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Judul dan isi wajib diisi.'),
        ),
      );

      return;
    }

    if (!formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      isSaving = true;
    });

    final note = Note(
      title: title,
      content: content,
      createdAt: DateTime.now().toIso8601String(),
    );

    try {
      await DatabaseHelper.instance.insertNote(note);

      if (!mounted) {
        return;
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan catatan'),
        ),
      );
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  hintText: 'Masukkan judul catatan',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Judul wajib diisi';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 16),

              TextFormField(
                controller: contentController,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  hintText: 'Masukkan isi catatan',
                  border: OutlineInputBorder(),
                ),
                minLines: 5,
                maxLines: 8,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Isi catatan wajib diisi';
                  }

                  if (value.trim().length < 5) {
                    return 'Isi minimal 5 karakter';
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              FilledButton(
                onPressed: isSaving ? null : saveNote,
                child: Text(
                  isSaving ? 'Menyimpan...' : 'Simpan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}