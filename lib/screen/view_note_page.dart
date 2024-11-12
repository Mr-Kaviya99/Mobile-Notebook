import 'package:flutter/material.dart';

import '../model/note_model.dart';
import 'edit_note_page.dart';

class ViewNotePage extends StatelessWidget {
  final Note note;

  const ViewNotePage({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.teal,
        title: const Text(
          'View Note',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.edit,
              color: Colors.white,
            ),
            onPressed: () async {

              final updatedNote = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EditNotePage(note: note),
                ),
              );
              if (updatedNote != null) {
                Navigator.pop(context, updatedNote);
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              note.content,
              style: const TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
