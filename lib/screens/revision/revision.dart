import 'package:audioplayers/audioplayers.dart';
import 'package:cool_ui/cool_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:plum_test/layout/revision_vertical.dart';
import 'package:animate_do/animate_do.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Revision extends StatefulWidget {
  const Revision({ Key key }) : super(key: key);

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  AudioCache player = AudioCache(prefix: 'assets/audio/');

  void initState() {
    super.initState();
    context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
    context.read<ImageData>().fetchClassData; //Fetch class data of type ImageData
    context.read<ImageData>().fetchVolumeData; //Fetch volume data for tts
    context.read<ImageData>().fetchRateData; //Fetch rate data for tts
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColors('#fb6542'),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () async {
            await player.play('click_pop.mp3');
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Icon(AntDesign.book, color: Colors.white, size: 45),
            SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
            Text('Revision',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              letterSpacing: .5,
            )),
            Spacer(),
          ],
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 8),
            child: CupertinoPopoverButton( //Button to display popover list
              child: Padding(padding: EdgeInsets.only(right: 8),
                child: Icon(Icons.info_outline, size: 35),
              ),
              popoverHeight: 325,
              popoverWidth: 390,
              onTap: (){
                player.play('click_pop.mp3');
                return false;
              },
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
                    popoverItem("Tap for Pronunciation", Icons.volume_up_rounded),
                    popoverItem("Swipe Left/Right for More Images", Icons.swipe),
                    popoverItem("Swipe Up for More Classes", MaterialCommunityIcons.gesture_swipe_up),
                    popoverItem("Swipe Down to Refresh", MaterialCommunityIcons.gesture_swipe_down),
                  ],
                );
              },
            )
          )
        ],
      ),

      body: BounceInDown(
        child: LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 500,
          showChildOpacityTransition: false,
          animSpeedFactor: 1.5,
          color: Colors.white,
          backgroundColor: hexColors('#fb6542'),
          onRefresh: () async {
            await context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
            await context.read<ImageData>().fetchClassData; //Fetch class data of type ImageData
            await context.read<ImageData>().fetchVolumeData; //Fetch volume data for tts
            await context.read<ImageData>().fetchRateData; //Fetch rate data for tts
          },
          child: Center(
            child: Consumer<ImageData>(
              builder: (context, value, child){
                return (value.classMap.length == 0 && !value.classError) //Check for availability of elements and errors for classMap
                && (value.imageMap.length == 0 && !value.imageError) //Check for availability of elements and errors for ImageMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : value.classError ? Text('Oops. ${value.classErrorMessage}',
                //Error message when classError == true
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ), )
                : value.imageError ? Text('Oops. ${value.imageErrorMessage}',
                //Error message when imageError == true
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                ), )
                : value.classMap.length == 0 && value.imageMap.length != 0
                //Load circular progress indicator when fetching data for classMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : value.imageMap.length == 0 && value.classMap.length != 0
                //Load circular progress indicator when fetching data for imageMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : ListView.builder(
                  itemCount: value.classResults.length, //Determine number of rows/total number of classes
                  itemBuilder: (context, index){
                    return VerticalView(classResult: value.classResults[index], imageResult: value.imageResults, 
                    volume: value.ttsVolume, rate: value.ttsRate);
                  }
                );
              },
            )
          )  
        ),
      )
    );
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }

  Widget popoverItem(String text, IconData iconData){ //Items for popover
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 0, 0, 15),
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
}
