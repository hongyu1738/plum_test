import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class CameraSpeech extends StatefulWidget {
  const CameraSpeech({ Key key, this.volume, this.rate, this.label }) : super(key: key);

  final double volume; 
  final double rate;
  final String label;

  @override
  _CameraSpeechState createState() => _CameraSpeechState();
}

class _CameraSpeechState extends State<CameraSpeech> {

  //Instantiate classification model
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: IconButton(
        onPressed: getSpeech,
        icon: Icon(Icons.volume_up_rounded),
        color: Colors.white,
        iconSize: 38,
        tooltip: "Press for pronounciation",
      ),
    );
  }

  getSpeech() async { //Function for text to speech without customization
    await flutterTts.setVolume(widget.volume);
    await flutterTts.setSpeechRate(widget.rate);
    await flutterTts.speak(widget.label);
  }
}