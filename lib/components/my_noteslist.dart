import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/firestore.dart';
import 'my_notecard.dart';

class NotesList extends StatelessWidget {
  const NotesList({
    Key? key,
    required this.user,
    required this.firestoreservice,
    required this.onNoteSelected,
    required this.trashCan,
    required this.toggleTrashCan, required this.listType,
  }) : super(key: key);

  final User user;
  final int listType;
  final FirestoreService firestoreservice;
  final void Function(String docID, Note note) onNoteSelected;
  final List<String> trashCan;
  final void Function(String docID) toggleTrashCan;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
              stream: firestoreservice.getNotesStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List notes = snapshot.data!.docs;
                  if(listType==1){
                    notes = notes.where((note) => note['isFavourite'] && !note['isLocked']).toList();
                  }
                  else if(listType == 2){
                    notes = notes.where((note) => note['isLocked']).toList();
                  }else{
                    notes = notes.where((note) => !note['isLocked']).toList();
                  }
                  return Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.all(10),
                      itemCount: notes.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot document = notes[index];
                        String docID = document.id;
                    
                        Note note = Note(
                          title: document['title'],
                          description: document['description'],
                          timestamp: document['timestamp'].toDate(),
                          isFavourtie: document['isFavourite'],
                          isLocked: document['isLocked']
                        );

                        DateTime date = DateTime(note.timestamp.year, note.timestamp.month, note.timestamp.day);
                    
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MyNoteCard(
                            noteID: docID,
                            trashcan: trashCan,
                            isSelected: trashCan.contains(docID),
                            title: note.title, 
                            timestamp:date,
                            onTap: () {
                              onNoteSelected(docID, note);
                              },
                            
                            onDelete: () {
                              toggleTrashCan(docID);
                              },
                            isFavourite: note.isFavourtie,
                            ),
                        );
                      },
                    ),
                  );
                }
              },
            );
  }
}