import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    label: Text('Learn'),
                    
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

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, '/revision');
                    },
                    icon: Icon(Icons.photo_album_rounded),
                    label: Text('Revision'),
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
                                style: GoogleFonts.ibmPlexSans(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                  //fontStyle: FontStyle.italic,
                                )),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
                                child: Text("Test your skills!",
                                style: GoogleFonts.ibmPlexSans(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 20,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                              ),
                              
                              ListTile(
                                title: Text('Vocabulary Quiz',
                                style: GoogleFonts.ibmPlexSans(
                                  //textStyle: Theme.of(context).textTheme.headline4,
                                  fontSize: 24,
                                  //fontWeight: FontWeight.w600,
                                  //fontStyle: FontStyle.italic,
                                )),
                                onTap: () {
                                  Navigator.pop(context);
                                  Navigator.pushNamed(context, '/vocabularyQuiz');
                                },
                              ),

                              SizedBox(height: 30),
                            ],
                          );
                        }
                      );
                    },

                    icon: Icon(Icons.games_rounded),
                    label: Text('Games'),

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

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.pushNamed(context, '/settings');
                    },
                    icon: Icon(Icons.settings),
                    label: Text('Settings'),
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
          ),
        ),
      )
    );
  }
}