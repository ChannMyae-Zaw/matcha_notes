// ignore_for_file: unused_import, override_on_non_overriding_member, collection_methods_unrelated_type, annotate_overrides, prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:matcha_notes/services/firestore.dart';
import 'package:matcha_notes/pages/edit_page.dart';
import 'package:matcha_notes/pages/home_page.dart';

import '../components/my_noteslist.dart';

class LockPage extends StatefulWidget {
  const LockPage({super.key});

  @override
  State<LockPage> createState() => _LockPageState();
}

class _LockPageState extends State<LockPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser!;
  FirestoreService firestoreservice = FirestoreService();
  late Future<List<Note>> userNotes;
  List<String> trashCan=[];
  exitsInTrashCan(Note note) => trashCan.contains(note);
  @override

      void toggleTrashCan(String docID) {
    setState(() {
      if (trashCan.contains(docID)) {
        trashCan.remove(docID);
      } else {
        trashCan.add(docID);
      }
    });
  }

    @override
  void initState() {
    super.initState();
    userNotes = fetchNotes();
  }

    Future<List<Note>> fetchNotes() async {
    return firestoreservice.getNotes(user.uid);
  }

  void editNote( String docID, Note note){
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditNote(
        note: note,
        id: docID,
        onNoteEdited: onNoteEdited,
        )
      )
    );
  }

  Future<void> onNoteEdited() async {
    userNotes = fetchNotes();
    setState(() {
      
    });
  }


  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: trashCan.isEmpty ? AppBar(
       automaticallyImplyLeading: false, // Remove the default back button
    leading: IconButton(
      icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      },
    ),
        backgroundColor: Color.fromRGBO(120, 144, 72, 1),
      ):AppBar(
        backgroundColor: Color.fromRGBO(184, 202, 148, 1),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 1.0),
          child: IconButton(
            onPressed: (){
              setState(() {
                for(String docID in trashCan){
                  firestoreservice.toggleLocked(docID);
                }
                trashCan.clear();
              });
            }, 
            icon: Icon(Icons.lock_open, size: 27, color: const Color.fromARGB(255, 69, 69, 69),)),
        ),
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: const Icon(Icons.delete, size: 30, color: const Color.fromARGB(255, 69, 69, 69),),
              onPressed:(){
              
              setState((){
                for(String docID in trashCan){
                  firestoreservice.deleteNote(docID);
                }
                trashCan.clear();
              });
            }),
          )],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 15.0, bottom: 5.0), // Adjust padding as needed
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Locked Notes',
                style: TextStyle( 
                color: Color.fromARGB(255, 31, 46, 0),
                fontSize: 40,
                fontWeight: FontWeight.bold// Setting underline color
              ),
              ),
            ),
          ),
          NotesList(
            user: user,
            firestoreservice: firestoreservice,
            onNoteSelected: editNote,
            trashCan: trashCan,
            toggleTrashCan: toggleTrashCan,
            listType: 2,
          )
        ],
      )
    );
  }
}