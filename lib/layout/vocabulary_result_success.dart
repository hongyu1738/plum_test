import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VocabularyResultSuccess extends StatelessWidget {
  const VocabularyResultSuccess({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColors('#ffbb00'),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text('Success',
        style: TextStyle(
          fontSize: 33,
          letterSpacing: .5,
        )),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (3/40)),

            Icon(AntDesign.smileo, color: Colors.white, size: 180),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            Text('Good Job!', style: TextStyle(fontSize: 34, color: Colors.white)),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            BounceInDown(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SimpleLineIcons.home, color: Colors.white, size: 45), 
                    SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
                    Text('Main Menu',
                      style: TextStyle(fontFamily: 'CrayonKids', fontSize: 28)
                    ),
                  ],
                ),

                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontFamily: 'CrayonKids',
                  ),
                )
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            BounceInDown(
              child: ElevatedButton(
                onPressed: (){
                  Navigator.of(context).pushReplacementNamed('/vocabularyQuiz');
                },
              
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Feather.repeat, color: Colors.white, size: 45), 
                    SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
                    Text('Try Another?', 
                      style: TextStyle(fontFamily: 'CrayonKids', fontSize: 28),
                    ),
                  ],
                ),

                style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontFamily: 'CrayonKids',
                  ),
                )
              ),
            ),
          ],
        )
      ),
    );
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }
}