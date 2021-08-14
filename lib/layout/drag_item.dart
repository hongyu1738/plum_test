import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DragItem extends StatelessWidget {
  const DragItem({ Key key, this.label }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        // decoration: BoxDecoration(
        //   border: Border.all(color: Colors.black),
        //   borderRadius: BorderRadius.circular(15),
        // ),
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.40,
        //padding: EdgeInsets.all(12),
        child: Text(label, style: GoogleFonts.ibmPlexSans(fontSize: 26, fontWeight: FontWeight.w400)),
      ),
    );
  }
}