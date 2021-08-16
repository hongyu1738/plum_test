import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class DragResultSuccess extends StatelessWidget {
  const DragResultSuccess({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Success',
        style: TextStyle(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w400,
          letterSpacing: .5,
          //fontStyle: FontStyle.italic,
        )),
        // titleTextStyle: TextStyle(
        //   fontSize: 24.0,
        // ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50),

            BounceInDown(
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(Icons.home_rounded),
                label: Text('Back to Main Menu',
                style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),
                style: ElevatedButton.styleFrom(
                  // background color
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ),
            ),

            SizedBox(height: 50),

            BounceInDown(
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/dragQuiz');
                },
                icon: Icon(Icons.autorenew_rounded),
                label: Text('Try Another?',
                style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),
                style: ElevatedButton.styleFrom(
                  // background color
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ),
            ),
          ],
        )
      ),
      
    );
  }
}