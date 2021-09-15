import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:plum_test/layout/revision_horizontal.dart';
import 'package:flutter_tts/flutter_tts.dart';

class VerticalView extends StatefulWidget {
  const VerticalView({ Key key, this.classResult, this.imageResult, this.volume, this.rate}) : super(key: key);
  final String classResult;
  final Map<String, dynamic> imageResult;
  final double volume; 
  final double rate;

  @override
  _VerticalViewState createState() => _VerticalViewState();
}

class _VerticalViewState extends State<VerticalView> {

  final FlutterTts flutterTts = FlutterTts();

  getSpeech() async { //Function for text to speech without customization
    await flutterTts.setVolume(widget.volume);
    await flutterTts.setSpeechRate(widget.rate);
    await flutterTts.speak(widget.classResult);
  }

  @override
  Widget build(BuildContext context) { //Create a row for each instance of a class in classResult list
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            children: [
              Text('${widget.classResult}', //Display class labels for images
                style: TextStyle(
                  fontSize: 40,
                  letterSpacing: .5,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0),
                child: IconButton(
                  onPressed: getSpeech, //Function for pronunciation
                  icon: Icon(Icons.volume_up_rounded),
                  color: Colors.white,
                  iconSize: 45,
                  tooltip: "Press for pronounciation",
                ),
              ),
            ],
          ),
        ),

        _divider(),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            
            child: AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageResult[widget.classResult].length,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList( //Slide animation when loading revision page
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: HorizontalView(imageUrl: widget.imageResult[widget.classResult][index]),
                      ),
                    ),
                  );
                }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _divider(){ //Divider
    return Divider(
      thickness: 5,
      indent: 20,
      endIndent: 20,
    );
  }
}

