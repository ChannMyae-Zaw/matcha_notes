/*import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  const MyWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
  padding: const EdgeInsets.fromLTRB(18, 10, 18, 0),
  child: SizedBox(
    width: double.infinity,
        height: 180,
    child: GestureDetector(
      onTap: () {
        Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => MemoPage(
        memo: memo,
        id: memoId,
        onMemoEdited: onMemoEdited,
        )
      )
    );
                 
      },
      child: Card(
        color: const Color.fromARGB(255, 120, 144, 72),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18, 8, 18, 8),
          child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      memo.title,
                      style: GoogleFonts.italianno(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                       memo.description,
                      style: GoogleFonts.italianno(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                )
            
          ),
        ),
      ),
    ),
  ),
  }
}*/