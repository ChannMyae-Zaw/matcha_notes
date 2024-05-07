// ignore_for_file: unused_import, must_be_immutable, override_on_non_overriding_member, annotate_overrides, prefer_const_constructors

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matcha_notes/services/firestore.dart';

class MyNoteCard extends StatefulWidget {
  final String noteID;
  final String title;
  final bool isSelected;
  final DateTime timestamp;
  final void Function()? onDelete;
  final void Function()? onTap;
  final List trashcan;
  bool isFavourite;

  
  MyNoteCard ({super.key, required this.title, required this.timestamp, this.onDelete, this.onTap, required this.trashcan, required this.isSelected, required this.noteID, required this.isFavourite});

  @override
  State<MyNoteCard> createState() => _MyNoteCardState();
}

class _MyNoteCardState extends State<MyNoteCard> {
  @override
  FirestoreService firestoreservice = FirestoreService();
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.trashcan.isNotEmpty ? widget.onDelete : widget.onTap,
      onLongPress: widget.onDelete,
      child: Card(
        elevation: widget.isSelected ? 8.0 : 0.0, // Add elevation when selected
        margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
        color: widget.isSelected ? Color.fromRGBO(184, 202, 148, 1) : Colors.white, // Change background color when selected
        child: Container(
          decoration: widget.isSelected // Add decoration for selected tile
              ? BoxDecoration(
                  border: Border.all(
                    color: Color.fromRGBO(120, 144, 72, 1), // Border color for selected tile
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                )
              : null,
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 3),
            leading: Container(
              padding: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                border: Border(
                  right: BorderSide(width: 1, color: Color.fromRGBO(120, 144, 72, 1)),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 0.0),
                child: Container(
                  height: 45,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(222, 213, 185, 1),
                  ),
                ),
              ),
            ),
            selected: widget.isSelected,
            title: Text(
              widget.title,
              style: TextStyle(
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.normal, // Bold text when selected
                color: widget.isSelected ? Colors.white : Colors.black, // Change text color when selected
              ),
            ),
            subtitle: Text(
              DateFormat('yyyy-MM-dd').format(widget.timestamp),
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.grey, // Change subtitle text color when selected
              ),
            ),
            trailing: IconButton(
              icon: widget.isFavourite
                  ? Icon(Icons.star, color: Color.fromRGBO(120, 144, 72, 1),)
                  : Icon(Icons.star_border_outlined, color: Color.fromRGBO(120, 144, 72, 1),),
              onPressed: () {
                firestoreservice.toggleFavourite(widget.noteID);
                setState(() {
                  widget.isFavourite = !widget.isFavourite;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}