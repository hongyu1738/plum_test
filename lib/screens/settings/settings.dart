import 'package:flutter/material.dart';

class Settings extends StatefulWidget {

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  bool value = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Settings'),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
        ),
      ),
      body: ListView(
        children: [
          buildCheckBox(),
        ],),
    );
  }

  Widget buildCheckBox() => ListTile(
    onTap: (){
      setState(() {
        this.value = !value;
      });
    },
      trailing: Checkbox(
      value: value,
      activeColor: Colors.orange[400],
      onChanged: (value){
        setState(() {
          this.value = value;
        });
      },
    ),
    title: Text('Save image to gallery', 
    style: TextStyle(
      fontSize: 20)
      ),
  );
}