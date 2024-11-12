import 'package:flutter/material.dart';
import 'package:notebook/screen/view_note_page.dart';

import '../helper/database_helper.dart';
import '../model/note_model.dart';
import 'edit_note_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Note> notes = [];

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  void _loadNotes() async {
    final loadedNotes = await DatabaseHelper.instance.fetchNotes();
    setState(() {
      notes = loadedNotes;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notebook',
            style: TextStyle(
              color: Colors.white,
            )),
        backgroundColor: Colors.teal[500],
      ),
      body: notes.isEmpty
          ? Center(
              child: Image.asset(
                "assets/notebook.png",
                height: 200,
                width: 200,
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return Card(
                    color: Colors.white,
                    elevation: 4.0,
                    margin: EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ListTile(
                        title: Text(
                          note.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          note.content,
                          style:
                              TextStyle(fontSize: 14, color: Colors.grey[700]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        onTap: () async {
                          final updatedNote = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ViewNotePage(note: note),
                            ),
                          );
                          if (updatedNote != null) {
                            _loadNotes();
                          }
                        },
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.teal[500]),
                              onPressed: () async {
                                final updatedNote = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditNotePage(note: note),
                                  ),
                                );
                                if (updatedNote != null) {
                                  _loadNotes();
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () async {
                                bool? confirmDelete = await showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text('Delete Note'),
                                    content: const Text(
                                        'Are you sure you want to delete this note?'),
                                    actions: [
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, false),
                                        child: Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, true),
                                        child: Text('Delete'),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirmDelete == true) {
                                  await DatabaseHelper.instance
                                      .delete(note.id!);
                                  _loadNotes();
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[500],
        onPressed: () async {
          final newNote = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditNotePage()),
          );
          if (newNote != null) {
            _loadNotes();
          }
        },
        child: Icon(
          Icons.note_add,
          color: Colors.white,
        ),
      ),
    );
  }
}
