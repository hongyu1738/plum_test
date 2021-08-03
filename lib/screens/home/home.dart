import 'package:flutter/material.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pushNamed(context, '/camera');
                  },
                  icon: Icon(Icons.book),
                  label: Text('Learn'),
                style: ElevatedButton.styleFrom(
                  // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                )
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pushNamed(context, '/revision');
                  },
                  icon: Icon(Icons.photo_album_rounded),
                  label: Text('Revision'),
                style: ElevatedButton.styleFrom(
                  // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                )
              ),

              SizedBox(height: 20),

              ElevatedButton.icon(
                  onPressed: (){
                    Navigator.pushNamed(context, '/settings');
                  },
                  icon: Icon(Icons.settings),
                  label: Text('Settings'),
                style: ElevatedButton.styleFrom(
                  // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(fontSize: 20),
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}