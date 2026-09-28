import 'package:flutter/material.dart';

import '../database/database_helper.dart';
import '../models/note.dart';

class EditNotePage extends StatefulWidget {
  final Note note;

  const EditNotePage({
    super.key,
    required this.note,
  });

  @override
  State<EditNotePage> createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  late final TextEditingController titleController;
  late final TextEditingController contentController;

  final formKey = GlobalKey<FormState>();

  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    titleController = TextEditingController(
      text: widget.note.title,
    );

    contentController = TextEditingController(
      text: widget.note.content,
    );
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> saveChanges() async {
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

    final updatedNote = Note(
      id: widget.note.id,
      title: title,
      content: content,
      createdAt: widget.note.createdAt,
    );

    try {
      await DatabaseHelper.instance.updateNote(updatedNote);

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
          content: Text('Gagal memperbarui catatan'),
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
        title: const Text('Edit Catatan'),
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
                onPressed: isSaving ? null : saveChanges,
                child: Text(
                  isSaving
                      ? 'Menyimpan...'
                      : 'Simpan Perubahan',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}