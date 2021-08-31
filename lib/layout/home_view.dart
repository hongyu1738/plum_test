import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plum_test/screens/settings/settings.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key key, this.volume }) : super(key: key);

  final double volume;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  AudioCache backgroundCache = AudioCache(prefix: 'assets/audio/');
  AudioPlayer backgroundPlayer;

  void playBackground() async {
    backgroundPlayer = await backgroundCache.loop("bensound-ukulele.mp3", volume: widget.volume);
    print(widget.volume);
  }

  void pauseBackground(){
    backgroundPlayer.pause();
  }

  void resumeBackground(){
    backgroundPlayer.resume();
  }

  void stopBackground(){
    backgroundPlayer.stop();
  }

  void changeVolume(double value){
    backgroundPlayer.setVolume(value);
  }

  @override
  Widget build(BuildContext context) {

    playBackground();

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          appBarButtons(resumeBackground, Icons.play_arrow),
          appBarButtons(pauseBackground, Icons.pause),
          appBarButtons(stopBackground, Icons.stop),
        ],
      ),

      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              menuButtons('/camera', 'Learn'),
              SizedBox(height: 20),
              menuButtons('/revision', 'Revision'),
              SizedBox(height: 20),
              BounceInDown(
                child: ElevatedButton.icon(
                  icon: Icon(Icons.games_rounded),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  label: Text('Games',
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)
                  ),
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
                                  fontSize: 36,
                                )
                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.fromLTRB(16, 8, 16, 20),
                              child: Text("Test your skills!",
                                style: TextStyle(
                                  fontSize: 22,
                                )
                              ),
                            ),
                                
                            gameButtons('/vocabularyQuiz', 'Vocabulary Games'),
                            gameButtons('/imageQuiz', 'Image Picker'),
                            gameButtons('/dragQuiz', 'Drag and Drop'),

                            SizedBox(height: 30),
                          ],
                        );
                      }
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              BounceInDown(
                child: ElevatedButton.icon(
                    onPressed: (){
                      Navigator.of(context).push(
                        new MaterialPageRoute(builder: (context){
                          return new Settings(resetVolume: changeVolume);
                        })
                      );
                    },
                    icon: Icon(Icons.settings),
                    label: Text('Settings',
                    style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),

                  style: ElevatedButton.styleFrom(
                    primary: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    textStyle: TextStyle(
                      fontSize: 24,
                    ),
                  )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget menuButtons(String menuRoute, String menuLabel){
    return BounceInDown(
      child: ElevatedButton.icon(
          onPressed: (){
            Navigator.pushNamed(context, menuRoute);
          },
          icon: Icon(Icons.photo_album_rounded),
          label: Text(menuLabel,
          style: TextStyle(fontFamily: 'CrayonKids', fontSize: 30)),

        style: ElevatedButton.styleFrom(
          primary: Colors.orange,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontSize: 24,
          ),
        )
      ),
    );
  }

  Widget gameButtons(String gameRoute, String gameLabel){
    return ListTile(
      contentPadding: EdgeInsets.only(left: 25),
      title: Text(gameLabel,
        style: TextStyle(
        fontSize: 30,
        )
      ),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushNamed(context, gameRoute);
      },
    );
  }

  Widget appBarButtons(Function appBarFunction, IconData iconName){
    return Padding(
      padding: EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: appBarFunction,
        child: Icon(iconName, color: Colors.black45),
      ),
    );
  }
}