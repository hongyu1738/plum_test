import 'package:audioplayers/audioplayers.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:plum_test/screens/settings/settings.dart';
import 'package:animated_background/animated_background.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:plum_test/user.dart';

class HomeView extends StatefulWidget {
  const HomeView({ Key key, this.volume }) : super(key: key);

  final double volume;

  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with SingleTickerProviderStateMixin, WidgetsBindingObserver{

  //Instantiate Audioplayer
  AudioCache backgroundCache = AudioCache(prefix: 'assets/audio/');
  AudioCache player = AudioCache(prefix: 'assets/audio/');
  AudioPlayer backgroundPlayer;
  String playerState;

  //Check if app is minimized or closed
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (playerState == "play"){ //If application is resumed when audio is playing
        resumeBackground();
      } else if (playerState == "pause"){ //If application is resumed when audio is paused
        pauseBackground();
      } else if (playerState == "stop"){ //If application is resumed when audio is stopped
        stopBackground();
      }
    } else { 
      if (playerState == "play"){ //If application is minimized when audio is playing
        backgroundPlayer.pause();
        setState(() {
          playerState = "play";
        });
      } else if (playerState == "pause"){ //If application is minimized when audio is paused
        pauseBackground();
      } else if (playerState == "stop"){ //If application is minimized when audio is stopped
        stopBackground();
      }
    }
  }

  //Function to play background music with specific volume
  Future playBackground() async {
    backgroundPlayer = await backgroundCache.loop("bensound-ukulele.mp3");
    await backgroundPlayer.setVolume(widget.volume);
    setState(() {
      playerState = "play";
    });
  }

  //Function to pause Audioplayer
  void pauseBackground(){
    backgroundPlayer.pause();
    setState(() {
      playerState = "pause";
    });
  }

  //Function to resume AudioPlayer
  void resumeBackground(){
    backgroundPlayer.resume();
    setState(() {
      playerState = "play";
    });
  }

  //Function to stop AudioPlayer
  void stopBackground(){
    backgroundPlayer.stop();
    setState(() {
      playerState = "stop";
    });
  }

  //Function to change volume of AudioPlayer
  void changeVolume(double value){
    backgroundPlayer.setVolume(value);
  }

  @override
  void initState() {
    super.initState();
    playBackground();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    backgroundPlayer.dispose();
    WidgetsBinding.instance.removeObserver(this);
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
        child: AnimatedBackground( //vsync for display of Animated Background
          behaviour: SpaceBehaviour(),
          vsync: this,

          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(height: MediaQuery.of(context).size.height * (1/18)),

                Text('PLUM', 
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 80,
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
                        SizedBox(width: MediaQuery.of(context).size.width * (1/27)),
                        Text('Games',
                          style: TextStyle(
                            fontFamily: 'MouseMemoirs',
                          )
                        ),
                      ],
                    ),
                    
                    style: ElevatedButton.styleFrom(
                      primary: hexColors('#ffbb00'),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 35,
                      ),
                    ),
                    
                    onPressed: () async { //Display modal bottom sheet on selection of Game option
                      await player.play('click_pop.mp3');
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
                                        onTap: () async {
                                          await player.play('click_pop.mp3');
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
                                    fontSize: 33,
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
                      onPressed: () async {
                        await player.play('click_pop.mp3');
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
                          SizedBox(width: MediaQuery.of(context).size.width * (1/27)),
                          Text('Settings',
                            style: TextStyle(
                              fontFamily: 'MouseMemoirs',
                            )
                          ),
                        ],
                      ),

                    style: ElevatedButton.styleFrom(
                      primary: hexColors('#3f681c'),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(
                        fontSize: 35,
                      ),
                    )
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height * (1/36)),
                exitButtons('/', 'Sign Out', hexColors('#f9a603'), Ionicons.md_exit),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //Display Sign Out button
  Widget exitButtons(String menuRoute, String menuLabel, Color hexColor, IconData iconName){
    return BounceInDown(
      child: ElevatedButton(
          onPressed: () async {
            await player.play('click_pop.mp3');
            User.username = "";
            User.password = "";
            Navigator.pushReplacementNamed(context, menuRoute);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconName, color: Colors.white, size: 45), 
              SizedBox(width: MediaQuery.of(context).size.width * (1/27)),
              Text(menuLabel,
                style: TextStyle(
                  fontFamily: 'MouseMemoirs', 
                )
              ),
            ],
          ),

        style: ElevatedButton.styleFrom(
          primary: hexColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontSize: 35,
          ),
        )
      ),
    );
  }

  //Display menu buttons
  Widget menuButtons(String menuRoute, String menuLabel, Color hexColor, IconData iconName){
    return BounceInDown(
      child: ElevatedButton(
          onPressed: () async {
            await player.play('click_pop.mp3');
            Navigator.pushNamed(context, menuRoute);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(iconName, color: Colors.white, size: 45), 
              SizedBox(width: MediaQuery.of(context).size.width * (1/27)),
              Text(menuLabel,
                style: TextStyle(
                  fontFamily: 'MouseMemoirs', 
                )
              ),
            ],
          ),

        style: ElevatedButton.styleFrom(
          primary: hexColor,
          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          textStyle: TextStyle(
            fontSize: 35,
          ),
        )
      ),
    );
  }

  Widget gameButtons(String gameRoute, String gameName, IconData iconName){ //Display options in modal bottom sheet
    return GestureDetector(
      onTap:() async {
        await player.play('click_pop.mp3');
        Navigator.pop(context);
        Navigator.pushNamed(context, gameRoute);
      },
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 16,
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
              padding: EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(gameName,
                style: TextStyle(
                  fontSize: 35,
                  color: Colors.white,
                )
              )
            ),
            Spacer(),
            
            gameName == 'Vocab Games' ?

            CupertinoPopoverButton(
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: 260,
              popoverWidth: 390,
              onTap: (){
                player.play('click_pop.mp3');
                return false;
              },
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 40
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap to Select Answer", AntDesign.select1),
                    popoverItem("Swipe Down to Refresh", MaterialCommunityIcons.gesture_swipe_down),
                    popoverItem("Tap to Refresh", Icons.refresh_rounded),
                  ],
                );
              },
            )

            : gameName == 'Image Picker' ?

            CupertinoPopoverButton(
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: 325,
              popoverWidth: 390,
              onTap: (){
                player.play('click_pop.mp3');
                return false;
              },
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 40
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap for Pronunciation", Icons.volume_up_rounded),
                    popoverItem("Tap to Select Answer", AntDesign.select1),
                    popoverItem("Swipe Down to Refresh", MaterialCommunityIcons.gesture_swipe_down),
                    popoverItem("Tap to Refresh", Icons.refresh_rounded),
                  ],
                );
              },
            )

            : 
            
            CupertinoPopoverButton( //Button to display popover list
              child: Icon(Icons.info_outline, size: 40, color: Colors.white),
              popoverHeight: 260,
              popoverWidth: 390,
              onTap: (){
                player.play('click_pop.mp3');
                return false;
              },
              direction: CupertinoPopoverDirection.top,
              popoverBuild: (BuildContext context){
                return CupertinoPopoverMenuList( //Display popover list
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Center(
                        child: Text("Instructions", 
                          style: TextStyle(
                            fontSize: 40
                          )
                        ),
                      ),
                    ),
                    popoverItem("Tap to Select Item", AntDesign.select1),
                    popoverItem("Drag Item to Answer", MaterialCommunityIcons.select_drag),
                    popoverItem("Tap to Refresh", Icons.refresh_rounded),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget appBarButtons(Function appBarFunction, IconData iconName){ //Display buttons on appBar
    return Padding(
      padding: EdgeInsets.only(right: 20),
      child: GestureDetector(
        onTap: appBarFunction,
        child: Icon(iconName, color: Colors.white, size: 30),
      ),
    );
  }

  Widget popoverItem(String text, IconData iconData){ //Display popover items
    return Padding(
      padding: EdgeInsets.fromLTRB(10, 0, 0, 15),
      child: Row(
        children: [
          Icon(iconData, size: 45),
          SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
          Text(text,
            style: TextStyle(
              fontSize: 28,
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