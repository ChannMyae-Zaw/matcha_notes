// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:matcha_notes/services/firestore.dart';
import 'package:google_fonts/google_fonts.dart';


import 'home_page.dart';


class MemoPage extends StatefulWidget {
   MemoPage({
    super.key,
    required this.memo,
    required this.id, required this.onMemoEdited,
  });

  Memo memo;
  final String id;
  final void Function() onMemoEdited;
  @override
  _MemoPageState createState() => _MemoPageState();
}

class _MemoPageState extends State<MemoPage> {
  TextEditingController _dateController = TextEditingController();
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  FirestoreService firestoreservice = FirestoreService();
  Memo? _currentMemo;

  @override
  void initState() {
    super.initState();
    _titleController = 
        TextEditingController(text: widget.memo.title == 'Daily Memo'?'': widget.memo.title);
    _descriptionController =
        TextEditingController(text: widget.memo.description == 'Write your memo here!'? '': widget.memo.description);
    _dateController.text = widget.memo.timestamp.toIso8601String().split("T")[0];
    _currentMemo = widget.memo;
    _dateController.addListener(_onDateChanged);

  }

  Future<void> _onDateChanged() async {
    if (_dateController.text.isNotEmpty) {
      DateTime selectedDate = DateTime.parse(_dateController.text);
      Memo? memo = await firestoreservice.getMemoForDate(selectedDate);
      if (memo != null) {
        setState(() {
          _currentMemo = memo; 
          _titleController.text = _isToday(_dateController.text) ? '' : (memo.title == "Daily Memo" ? 'No Memo on ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'  : memo.title);
          _descriptionController.text = _isToday(_dateController.text) ? '': (memo.description == "Write your memo here!"? 'Don\'t forget to write your memo next time!' : memo.description) ;
        });
      } else {
        // Memo doesn't exist for the selected date, reset to the original memo
        setState(() {
          _currentMemo = widget.memo;
          _titleController.text = 'No Memo on ${selectedDate.day}/${selectedDate.month}/${selectedDate.year}';
          _descriptionController.text = 'Don\'t forget to write your memo next time!';
        });
      }
      print(_currentMemo!.description);
    }
  }
  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

      Future<void> _selectDate() async{
      DateTime ? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime.now(),
        builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.light().copyWith(
          colorScheme: ColorScheme.light().copyWith(
            primary: Color.fromARGB(255, 120, 144, 72), // Change primary color to green
          ),
        ),
        child: child!,
      );
    },
      );

      if (_picked != null){
        setState((){
          _dateController.text = _picked.toString().split(" ")[0];
        });
        await _onDateChanged();
      }
    }

  bool _isToday(String dateString) {
  DateTime selectedDate = DateTime.parse(dateString);
  DateTime now = DateTime.now();
  return selectedDate.year == now.year && selectedDate.month == now.month && selectedDate.day == now.day;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          color: Colors.white,
          onPressed:() {Navigator.of(context).pop();},),
        backgroundColor:const Color.fromARGB(255, 120, 144, 72),

        
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: ListView(
          children: [
            SizedBox(height: 10,),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(
                filled: true,
                fillColor: Color.fromARGB(255, 120, 144, 72),
                prefixIcon: Padding(
                  padding: EdgeInsets.only(left: 15, right: 10), // Adjust the padding as needed
                  child: Icon(
                    Icons.calendar_today,
                    color: Colors.white, // Set the icon color
                    size: 20, // Set the icon size
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color :Color.fromARGB(255, 120, 144, 72))
                )
              ),
              readOnly: true,
              onTap:(){
                _selectDate();
              },
              style: TextStyle(
                color: Colors.white, // Set the text color
                fontSize: 20,
              )
            ),
            TextFormField(
              readOnly: !_isToday(_dateController.text),
              controller: _titleController,
              decoration: const InputDecoration(
                hintText: 'Daily Memo',
              ),
              style: GoogleFonts.patrickHand(
                fontSize: 28,
                fontWeight: FontWeight.w500,
                ),
              maxLines: null,
            ),
            TextFormField(
              readOnly: !_isToday(_dateController.text),
              decoration: const InputDecoration(
                hintText: 'Write your memo here!',
                border: InputBorder.none,
              ),
              controller: _descriptionController,
              style: GoogleFonts.patrickHand(fontSize: 18),
              maxLines: null,
            ),
          ],
        ),
      ),
       floatingActionButton: _dateController.text.isNotEmpty && _isToday(_dateController.text) 
      ? FloatingActionButton(
        backgroundColor:const Color.fromARGB(255, 120, 144, 72),
        onPressed: () {
          String body = (_descriptionController.text.isEmpty) ? 'Write your memo here!' : _descriptionController.text;
            String title = (_titleController.text.isEmpty) ? 'Daily Memo' : _titleController.text;

          firestoreservice.editMemo( widget.id, title,body );
          widget.onMemoEdited();
          Navigator.of(context).pop();
        },
        child: const Icon(
          Icons.save,
          color: Colors.white,
          ),        
      ):null,
    );
  }
}
