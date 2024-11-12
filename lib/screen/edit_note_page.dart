import 'package:flutter/material.dart';
import '../helper/database_helper.dart';
import '../model/note_model.dart';

class EditNotePage extends StatefulWidget {
  final Note? note;

  const EditNotePage({super.key, this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
    }
  }

  void _saveNote() async {
    final title = _titleController.text;
    final content = _contentController.text;

    if (title.isEmpty || content.isEmpty) return;

    if (widget.note == null) {
      final newNote = Note(
        title: title,
        content: content,
      );
      await DatabaseHelper.instance.insert(newNote);
    } else {
      final updatedNote = widget.note!.copyWith(
        title: title,
        content: content,
      );
      await DatabaseHelper.instance.update(updatedNote);
    }

    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          widget.note == null ? 'Add Note' : 'Edit Note',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              labelText: 'Title',
              labelStyle: TextStyle(color: Colors.teal),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                    color: Colors.grey,
                    width: 1.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.teal, width: 2.0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: _contentController,
            decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.teal),
                alignLabelWithHint: true,
                border: OutlineInputBorder(),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                  color: Colors.grey,
                  width: 1.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.teal, width: 2.0),
            ),
          ),
          maxLines: 5,
          maxLength: 1000,
          keyboardType: TextInputType.multiline,
        ),
        const SizedBox(height: 20),
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            onPressed: _saveNote,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
              textStyle: const TextStyle(fontSize: 16),
            ),
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        ],
      ),
    ),)
    ,
    );
  }
}
