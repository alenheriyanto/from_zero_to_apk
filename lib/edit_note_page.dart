import 'package:flutter/material.dart';

import 'database/database_helper.dart';
import 'models/note.dart';

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
    if (!formKey.currentState!.validate()) {
      return;
    }

    final updatedNote = Note(
      id: widget.note.id,
      title: titleController.text.trim(),
      content: contentController.text.trim(),
      createdAt: widget.note.createdAt,
    );

    await DatabaseHelper.instance.updateNote(updatedNote);

    if (!mounted) {
      return;
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Catatan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
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

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveChanges,
                  child: const Text('Simpan Perubahan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}