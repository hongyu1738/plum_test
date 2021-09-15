import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:flutter_icons/flutter_icons.dart';

class VocabularyResultFailure extends StatelessWidget {
  const VocabularyResultFailure({ Key key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: hexColors('#ffbb00'),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ), 
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Icon(AntDesign.closecircleo, color: Colors.white, size: 45),
            SizedBox(width: MediaQuery.of(context).size.width * (1/27)),
            Text('Incorrect',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              letterSpacing: .5,
            )),
            Spacer(flex: 2),
          ],
        ),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * (3/40)),

            Icon(AntDesign.frowno, color: Colors.white, size: 180),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            Text('Oh No!', style: TextStyle(fontSize: 40, color: Colors.white)),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            BounceInDown(
              child: ElevatedButton(
                onPressed: (){ //Pop until first page
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(SimpleLineIcons.home, color: Colors.white, size: 40), 
                    SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
                    Text('Main Menu'),
                  ],
                ),

                style: ElevatedButton.styleFrom(
                  primary: hexColors('#f9a603'),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontFamily: 'MouseMemoirs',
                  ),
                )
              ),
            ),

            SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

            BounceInDown(
              child: ElevatedButton(
                onPressed: (){ //Pop current page
                  Navigator.pop(context);
                },

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Feather.repeat, color: Colors.white, size: 40), 
                    SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
                    Text('Try Again?'),
                  ],
                ),

                style: ElevatedButton.styleFrom(
                  primary: hexColors('#f9a603'),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: TextStyle(
                    fontSize: 35,
                    fontFamily: 'MouseMemoirs',
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