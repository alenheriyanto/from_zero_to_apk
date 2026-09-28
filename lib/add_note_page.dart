import 'package:flutter/material.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({super.key});

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Catatan'),
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
                ),
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

              ElevatedButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) {
                    return;
                  }

                  final note = {
                    'title': titleController.text.trim(),
                    'content': contentController.text.trim(),
                  };

                  Navigator.pop(context, note);
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}