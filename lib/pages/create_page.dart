// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:matcha_notes/services/firestore.dart';

class CreateNote extends StatefulWidget {
  const CreateNote({super.key, required this.onNewNoteCreated,});
  final Function() onNewNoteCreated;

  @override
  State<CreateNote> createState() => _CreateNoteState();
}

class _CreateNoteState extends State<CreateNote> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirestoreService firestoreService = FirestoreService();
  final titleController = TextEditingController();
  final bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            ),
          onPressed:() {Navigator.of(context).pop();},),
        backgroundColor: const Color.fromARGB(255, 120, 144, 72),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            TextFormField(
              controller: titleController,
              style: const TextStyle(
                fontSize:28,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                hintText: "Title",
              ),
              maxLines: null,
            ),
            TextFormField(
              controller: bodyController,
              style: const TextStyle(
                fontSize:18
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: "Your note!",
              ),
              maxLines: null,
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 120, 144, 72),
        onPressed: () async {
    
          String body = (bodyController.text.isEmpty) ? '' : bodyController.text;
          String title = (titleController.text.isEmpty) ? 'Untitled' : titleController.text;
          final note = Note(
            title: title,
            description: body,
            timestamp: DateTime.now(),
            isFavourtie: false,
            isLocked: false,
          );
    
          try {
    await firestoreService.addNote(user.uid,note);
    widget.onNewNoteCreated();
    Navigator.pop(context);
      } catch (e) {
    print('Error adding note: $e');
    // Handle error, e.g., show an error message to the user
      }
        },
        child: const Icon(
          Icons.save,
          color: Colors.white),
      ),
    );
  }
}