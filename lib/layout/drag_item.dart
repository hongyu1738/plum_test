import 'package:flutter/material.dart';

class DragItem extends StatelessWidget {
  const DragItem({ Key key, this.label }) : super(key: key);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width * 0.40,
        child: Text(label, style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400)),
      ),
    );
  }
}