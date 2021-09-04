import 'package:audioplayers/audioplayers.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plum_test/screens/settings/settings.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key key, this.volume }) : super(key: key);

  final double volume;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin{

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
  void initState() {
    super.initState();
    playBackground();
  }

  @override
  Widget build(BuildContext context) {
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
        color: Colors.black,
        child: AnimatedBackground(
          behaviour: SpaceBehaviour(),
          vsync: this,

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text('PLUM', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                  )
                ),

                SizedBox(height: MediaQuery.of(context).size.height * (1/36)),

                menuButtons('/camera', 'Learn', hexColors('#375e97'), SimpleLineIcons.camera),
                SizedBox(height: MediaQuery.of(context).size.height * (1/36)),

                menuButtons('/revision', 'Revision', hexColors('#fb6542'), AntDesign.book),
                SizedBox(height: MediaQuery.of(context).size.height * (1/36)),

                BounceInDown(
                  child: ElevatedButton(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(SimpleLineIcons.game_controller, color: Colors.white, size: 45), 
                        SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
                        Text('Games',
                          style: TextStyle(
                            fontFamily: 'CrayonKids',
                          )
                        ),
                      ],
                    ),
                    
                    style: ElevatedButton.styleFrom(
                      primary: hexColors('#ffbb00'),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 28,
                      ),
                    ),
                    
                    onPressed: (){
                      showMaterialModalBottomSheet(
                        bounce: true,
                        backgroundColor: hexColors('#ffbb00'),
                        context: context, 
                        builder: (context){
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
                                child: Row(
                                  children: [
                                    SizedBox(width: MediaQuery.of(context).size.width * (1/72)),
                                    Icon(SimpleLineIcons.game_controller, color: Colors.white, size: 45),
                                    SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
                                    Text("Games",
                                      style: TextStyle(
                                        fontSize: 40,
                                        color: Colors.white,
                                      )
                                    ),
                                    Spacer(),
                                    Container(
                                      child: GestureDetector(
                                        onTap: (){
                                          Navigator.pop(context);
                                        },
                                        child: Icon(Icons.close, color: Colors.white, size: 45),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                padding: EdgeInsets.fromLTRB(25, 10, 0, 15),
                                child: Text("Test your skills!",
                                  style: TextStyle(
                                    fontSize: 28,
                                    color: Colors.white,
                                  )
                                ),
                              ),
                                  
                              gameButtons('/vocabularyQuiz', 'Vocab Games', Entypo.language),
                              gameButtons('/imageQuiz', 'Image Picker', Feather.image),
                              gameButtons('/dragQuiz', 'Drag and Drop', MaterialCommunityIcons.arrow_expand_all),
                            ],
                          );
                        }
                      );
                    },
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * (1/36)),

                BounceInDown(
                  child: ElevatedButton(
                      onPressed: (){
                        Navigator.of(context).push(
                          new MaterialPageRoute(builder: (context){
                            return new Settings(resetVolume: changeVolume);
                          })
                        );
                      },

                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(SimpleLineIcons.settings, color: Colors.white, size: 45), 
                          SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
                          Text('Settings',
                            style: TextStyle(
                              fontFamily: 'CrayonKids',
                            )
                          ),
                        ],
                      ),

                    style: ElevatedButton.styleFrom(
                      primary: hexColors('#3f681c'),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 28,
                      ),
                    )
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget menuButtons(String menuRoute, String menuLabel, Color hexColor, IconData iconName){
    return BounceInDown(
      child: ElevatedButton(
          onPressed: (){
            Navigator.pushNamed(context, menuRoute);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconName, color: Colors.white, size: 45), 
              SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
              Text(menuLabel,
                style: TextStyle(
                  fontFamily: 'CrayonKids', 
                )
              ),
            ],
          ),

        style: ElevatedButton.styleFrom(
          primary: hexColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontSize: 28,
          ),
        )
      ),
    );
  }

  Widget gameButtons(String gameRoute, String gameName, IconData iconName){
    return GestureDetector(
      onTap:(){
        Navigator.pop(context);
        Navigator.pushNamed(context, gameRoute);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24.0,
          vertical: 16.0,
        ),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.white,
              width: 0.1,
            ),
            bottom: BorderSide(
              color: Colors.white,
              width: 0.1,
            ),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            Icon(iconName, color: Colors.white, size: 45),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Text(gameName,
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                )
              )
            ),
            Spacer(),
            
            gameName == 'Vocab Games' ?

            CupertinoPopoverButton(
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: MediaQuery.of(context).size.height * 0.27,
              popoverWidth: MediaQuery.of(context).size.width * 0.95,
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 34
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap to Select Answer", AntDesign.select1),
                    popoverItem("Swipe Down to Refresh", MaterialCommunityIcons.gesture_swipe_down),
                  ],
                );
              },
            )

            : gameName == 'Image Picker' ?

            CupertinoPopoverButton(
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: MediaQuery.of(context).size.height * 0.35,
              popoverWidth: MediaQuery.of(context).size.width * 0.95,
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 34
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap for Pronunciation", Icons.volume_up_rounded),
                    popoverItem("Tap to Select Answer", AntDesign.select1),
                    popoverItem("Swipe Down to Refresh", MaterialCommunityIcons.gesture_swipe_down),
                  ],
                );
              },
            )

            : 
            
            CupertinoPopoverButton(
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: MediaQuery.of(context).size.height * 0.27,
              popoverWidth: MediaQuery.of(context).size.width * 0.95,
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 34
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap to Select Item", AntDesign.select1),
                    popoverItem("Drag Item to Answer", MaterialCommunityIcons.select_drag),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget appBarButtons(Function appBarFunction, IconData iconName){
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: appBarFunction,
        child: Icon(iconName, color: Colors.white, size: 30),
      ),
    );
  }

  Widget popoverItem(String text, IconData iconData){
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
      child: Row(
        children: [
          Icon(iconData, size: 40),
          SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
          Text(text,
            style: TextStyle(
              fontSize: 20,
            )
          ),
        ],
      ),
    );
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }
}