import 'package:flutter/material.dart';

class DragItem extends StatelessWidget {
  const DragItem({ Key key, this.label }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) { //Individual drag item
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.4,
        child: Text(label, style: TextStyle(fontSize: 35, fontWeight: FontWeight.w400, color: Colors.white)),
      ),
    );
  }
}