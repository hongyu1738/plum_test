import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class Home extends StatelessWidget {
  const Home({ Key key }) : super(key: key);

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
                    icon: Icon(Icons.camera_alt_rounded),
                    label: Text('Learn', 
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),
                    
                  style: ElevatedButton.styleFrom(
                    // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                      //fontWeight: FontWeight.w500,
                    ),
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
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),

                  style: ElevatedButton.styleFrom(
                    // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                      //fontWeight: FontWeight.w500,
                    ),
                  )
                ),
              ),

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      showMaterialModalBottomSheet(
                        context: context, 
                        builder: (context){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                                child: Text("Games",
                                style: TextStyle(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 36,
                                  //fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                )),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
                                child: Text("Test your skills!",
                                style: TextStyle(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 22,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                              ),
                              
                              ListTile(
                                contentPadding: EdgeInsets.only(left: 25),
                                title: Text('Vocabulary Quiz',
                                style: TextStyle(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 30,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/vocabularyQuiz');
                                },
                              ),

                              ListTile(
                                contentPadding: EdgeInsets.only(left: 25),
                                title: Text('Image Quiz',
                                style: TextStyle(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 30,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/imageQuiz');
                                },
                              ),

                              ListTile(
                                contentPadding: EdgeInsets.only(left: 25),
                                title: Text('Drag and Drop',
                                style: TextStyle(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 30,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/dragQuiz');
                                },
                              ),

                              SizedBox(height: 30),
                            ],
                          );
                        }
                      );
                    },

                    icon: Icon(Icons.games_rounded),
                    label: Text('Games',
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),

                  style: ElevatedButton.styleFrom(
                    // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                      //fontWeight: FontWeight.w500,
                    ),
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
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),

                  style: ElevatedButton.styleFrom(
                    // background color
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                      //fontWeight: FontWeight.w500,
                    ),
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