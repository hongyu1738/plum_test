import 'package:flutter/material.dart';
//import 'package:scroll_snap_list/scroll_snap_list.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class Revision extends StatefulWidget {

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  @override
    void initState() {
      super.initState();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Revision'),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
        ),
      ),
    );
  }
}
