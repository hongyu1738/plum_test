import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';

class VocabularyResultFailure extends StatelessWidget {
  const VocabularyResultFailure({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Fail',
        style: GoogleFonts.ibmPlexSans(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 26,
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
            //Text("Vocabulary result failure page"),

            SizedBox(height: 50),

            BounceInDown(
              child: ElevatedButton.icon(
                onPressed: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                icon: Icon(Icons.home_rounded),
                label: Text('Back to Main Menu'),
                style: ElevatedButton.styleFrom(
                  // background color
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: GoogleFonts.ibmPlexSans(
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
                  Navigator.pop(context);
                },
                icon: Icon(Icons.home_rounded),
                label: Text('Try Again?'),
                style: ElevatedButton.styleFrom(
                  // background color
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: GoogleFonts.ibmPlexSans(
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