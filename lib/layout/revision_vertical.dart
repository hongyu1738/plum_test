import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plum_test/layout/revision_horizontal.dart';
import 'package:flutter_tts/flutter_tts.dart';
//import 'package:plum_test/models/image_model.dart';

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
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Row(
            children: [
              Text('${widget.classResult}',
                style: GoogleFonts.ibmPlexSans(
                  fontSize: 32,
                  fontWeight: FontWeight.w400,
                  letterSpacing: .5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: IconButton(
                  onPressed: getSpeech,
                  icon: Icon(Icons.volume_up_rounded),
                  color: Colors.grey[800],
                  iconSize: 38,
                  tooltip: "Press for pronounciation",
                ),
              ),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: SizedBox(
            height: 200,
            child: AnimationLimiter(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: widget.imageResult[widget.classResult].length,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList(
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
}

