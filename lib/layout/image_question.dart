import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ImageQuestion extends StatefulWidget {
  const ImageQuestion({ Key key, this.imageLabel, this.imageUrl, this.urlChoices, this.imagePlayer, this.volume, this.rate, this.sfxVolume }) : super(key: key);

  final String imageLabel;
  final String imageUrl;
  final List<String> urlChoices;
  final AudioCache imagePlayer;
  final double volume;
  final double rate;
  final double sfxVolume;

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
            SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
            IconButton(
              onPressed: getSpeech,
              icon: Icon(Icons.volume_up_rounded),
              color: Colors.white,
              iconSize: 45,
              tooltip: "Press for pronounciation",
            ),
          ],
        ),
        showQuizImage(context, widget.urlChoices, widget.sfxVolume),
      ],
    );
  }

  Widget showQuizImage(BuildContext context, List<String> urlChoices, double volume) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.72,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: urlChoices.length,
        itemBuilder: (context, index){
          return InkWell(
            onTap: () => [compareResult(context, index, volume)],
            splashColor: Colors.orangeAccent,
            child: showIndividualImage(context, urlChoices[index]));
      }),
    ),
  );

  Widget showIndividualImage(BuildContext context, String url) => Padding(
    padding: EdgeInsets.fromLTRB(8, 0, 8, 15),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.33,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 0.1),
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(url), //Load image if image is selected
            fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget showQuizLabel(String label) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 0.0),
      child: Text("$label", 
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w400,
          letterSpacing: .5,
          color: Colors.white,
        ),
      ),
    );

  void compareResult(BuildContext context, int index, double volume){

    if(widget.imageUrl == widget.urlChoices[index]){
      widget.imagePlayer.play("win.wav", volume: volume);
      Navigator.of(context).pushReplacementNamed('/imageResultSuccess');
    } else {
      widget.imagePlayer.play("lose.wav", volume: volume);
      Navigator.of(context).pushNamed('/imageResultFailure');
    }
  }
}