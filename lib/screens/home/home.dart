import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, '/camera');
                    },
                    icon: Icon(Icons.book),
                    label: Text('Learn', 
                    style: GoogleFonts.lato(
                      //textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    )),
                    
                  style: ElevatedButton.styleFrom(
                    // background color
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                  )
                ),
              ),

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, '/revision');
                    },
                    icon: Icon(Icons.photo_album_rounded),
                    label: Text('Revision',
                    style: GoogleFonts.lato(
                      //textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    )),
                  style: ElevatedButton.styleFrom(
                    // background color
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                  )
                ),
              ),

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: Icon(Icons.settings),
                    label: Text('Settings',
                    style: GoogleFonts.lato(
                      //textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                    )),
                  style: ElevatedButton.styleFrom(
                    // background color
                      primary: Colors.orange,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 20),
                  )
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}