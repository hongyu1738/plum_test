import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
//import 'dart:async';

import 'package:flutter_tts/flutter_tts.dart';

class ImageQuestion extends StatefulWidget {
  const ImageQuestion({ Key key, this.imageLabel, this.imageUrl, this.urlChoices, this.imagePlayer, this.volume, this.rate }) : super(key: key);

  final String imageLabel;
  final String imageUrl;
  final List<String> urlChoices;
  final AudioCache imagePlayer;
  final double volume;
  final double rate;

  @override
  _ImageQuestionState createState() => _ImageQuestionState();
}

class _ImageQuestionState extends State<ImageQuestion> {

  final FlutterTts flutterTts = FlutterTts();

  getSpeech() async { //Function for text to speech without customization
    await flutterTts.setVolume(widget.volume);
    await flutterTts.setSpeechRate(widget.rate);
    await flutterTts.speak(widget.imageLabel);
  }

  @override
  Widget build(BuildContext context) {

    widget.imagePlayer.loadAll(["win.wav", "lose.wav"]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            showQuizLabel(widget.imageLabel),
            Padding(
                padding: EdgeInsets.only(left: 8.0),
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
        showQuizImage(context, widget.urlChoices),
      ],
    );
  }

  Widget showQuizImage(BuildContext context, List<String> urlChoices) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.68,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: urlChoices.length,
        itemBuilder: (context, index){
          return InkWell(
            onTap: () => [compareResult(context, index)],
            splashColor: Colors.orangeAccent,
            child: showIndividualImage(context, urlChoices[index]));
      }),
    ),
  );

  Widget showIndividualImage(BuildContext context, String url) => Padding(
    padding: const EdgeInsets.all(12.0),
    child: Container(
      //padding: const EdgeInsets.all(12),
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(url), //Load image if image is selected
            fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget showQuizLabel(String label) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 0.0),
      child: Text("$label", 
        style: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        //fontStyle: FontStyle.italic,
        letterSpacing: .5,
      ),),
    );

  void compareResult(BuildContext context, int index){

    if(widget.imageUrl == widget.urlChoices[index]){
      // Timer(Duration(milliseconds: 600), () {
        
      // });
      widget.imagePlayer.play("win.wav");
      Navigator.of(context).pushReplacementNamed('/imageResultSuccess');
      //Navigator.of(context).popAndPushNamed('/vocabularyResultSuccess');
    } else {
      //Navigator.of(context).pushNamed('/vocabularyResultFailure');
      // Timer(Duration(milliseconds: 600), () {
        
      // });
      widget.imagePlayer.play("lose.wav");
      Navigator.of(context).pushNamed('/imageResultFailure');
    }
  }
}