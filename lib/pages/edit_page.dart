// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:matcha_notes/services/firestore.dart';


class EditNote extends StatefulWidget {
  const EditNote({
    super.key,
    required this.note,
    required this.id,
    required this.onNoteEdited,
  });

  final Note note;
  final String id;
  final void Function() onNoteEdited;

  @override
  _EditNoteState createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  FirestoreService firestoreservice = FirestoreService();

  @override
  void initState() {
    super.initState();
    _titleController = 
        TextEditingController(text: widget.note.title);
    _descriptionController =
        TextEditingController(text: widget.note.description);
    

  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed:() {
              _titleController.text = widget.note.title;
              _descriptionController.text = widget.note.description;
            Navigator.of(context).pop();},),
        backgroundColor:const Color.fromARGB(255, 120, 144, 72),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: [
            TextFormField(
              controller: _titleController,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                ),
              maxLines: null,
            ),
            TextFormField(
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              controller: _descriptionController,
              style: const TextStyle(fontSize: 18),
              maxLines: null,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 120, 144, 72),
        onPressed: () {
          String body = (_descriptionController.text.isEmpty) ? '' : _descriptionController.text;
            String title = (_titleController.text.isEmpty) ? 'Untitled' : _titleController.text;

          final editedNote = Note(
            title: title,
            description: body,
            timestamp: DateTime.now(),
            isFavourtie: widget.note.isFavourtie,
            isLocked: widget.note.isLocked
          );

          firestoreservice.updateNote( widget.id, editedNote );
          widget.onNoteEdited();
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
          ),
        
      ),
    );
  }
}
