import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:plum_test/layout/drag_item.dart';
import 'dart:math';
import 'package:animate_do/animate_do.dart';

class DragAndDrop extends StatefulWidget {
  const DragAndDrop({ Key key }) : super(key: key);

  @override
  _DragAndDropState createState() => _DragAndDropState();
}

class _DragAndDropState extends State<DragAndDrop> {

  final Map<String, bool> score = {};
  Random random = new Random();
  int randomNum;
  final dragPlayer = AudioCache(prefix: 'assets/audio/');
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  void initState() {
    super.initState();
    context.read<ImageData>().fetchDragData;
    context.read<ImageData>().fetchSfxVolume;
    randomNum = random.nextInt(10); //Random number generator to randomize order of answers
    dragPlayer.loadAll(["single_correct.wav", "win.wav"]); //Preload sound effects for smoother plays
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hexColors('#ffbb00'),
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Icon(MaterialCommunityIcons.arrow_expand_all, color: Colors.white, size: 45),
            SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
            Text('Drag and Drop',
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              letterSpacing: .5,
            )),
            Spacer(),
          ],
        ),
        actions: [
          Padding(padding: EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () async { //Clear score and refetch DragData and SfxVolume on refresh
                await context.read<ImageData>().fetchDragData;
                await context.read<ImageData>().fetchSfxVolume;
                setState(() {
                  score.clear();          
                });
              },
              child: Icon(Icons.refresh_rounded, size: 30),
            ),
          )
        ],
      ),

      body: BounceInDown(
        child: Center(
          child: Consumer<ImageData>(
            builder: (context, value, child){
              return (value.dragMap.length == 0 && !value.dragError)
              ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
              : value.dragError ? Center(
                child: Text('Oops. \n${value.dragErrorMessage}',
                //Error message when dragError == true
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                ), ),
              )
              : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: value.dragMap.keys.map((label){
                      return Draggable<String>( //Draggable item
                        data: score[label] == true ? '' : label,
                        child: DragItem(label: score[label] == true ? '' : label), 
                        feedback: DragItem(label: score[label] == true ? '' : label),
                        childWhenDragging: DragItem(label: ''),
                      );
                    }).toList()
                  ),

                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: value.dragMap.entries.map((e) => dropItem(e.key, e.value, value.sfxVolume)).toList()..shuffle(Random(randomNum)),
                    //Shuffle position of drop items
                  )
                ],
              );
            }
          ),
        ),
      ) 
    );
  }

  Widget dropItem(String label, String url, double volume) => DragTarget<String>( //Drop item
    builder: (BuildContext context, List<String> accepted, List rejected){
      if (score[label] == true) {
        return Container(
          child: Icon(AntDesign.checkcircleo, color: Colors.white, size: 40),
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.35,
        );
      } else {
        return Container(
          height: MediaQuery.of(context).size.height * 0.25,
          width: MediaQuery.of(context).size.width * 0.35,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 0.5),
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: NetworkImage(url), //Load image if image is selected
                fit: BoxFit.contain,
            ),
          ),
        );
      }
    },
    onWillAccept: (data) => data == label, //Only accept draggable if the draggable data is equivalent to label
    onAccept: (data) {
      setState(() {
        score[label] = true; //Add true to score map if draggable data is equivalent to label
      });
      compareResult(context, score, volume);
      dragPlayer.play("single_correct.wav", volume: volume); 
      //Play sound effects on each successful match
    },
    onLeave: (data){},
  );

  //Function to compare results 
  //Play sound effects and navigate to next page based on results
  void compareResult(BuildContext context, Map score, double volume){
    if (score.length == 3){
      dragPlayer.play("win.wav", volume: volume);
      Navigator.of(context).pushReplacementNamed('/dragResultSuccess');
    }
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }
}
