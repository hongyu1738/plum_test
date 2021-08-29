import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class VocabularyQuestion extends StatelessWidget {
  const VocabularyQuestion({ Key key, this.vocabularyLabel, this.vocabularyUrl, this.choicesList, this.vocabularyPlayer }) : super(key: key);

  final String vocabularyLabel;
  final String vocabularyUrl;
  final List<String> choicesList;
  final AudioCache vocabularyPlayer;

  @override
  Widget build(BuildContext context) {

    vocabularyPlayer.loadAll(["win.wav", "lose.wav"]);

    return Column(
      children: [
        showQuestionImage(context, vocabularyUrl),
        buildGrid(context, choicesList),
      ],
    );
  }

  Widget showQuestionImage(BuildContext context, String url) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.35,
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

  Widget buildGrid(BuildContext context, List choices) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: 300,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4/3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10), 
        itemCount: choices.length,
        itemBuilder: (context, index){
          return InkWell(
              onTap: () => [compareResult(context, index)],
              splashColor: Colors.orangeAccent,
              child: showQuestionChoices(choices[index])
          );
        }
      ),
    ),
  );

  Widget showQuestionChoices(String choice) => Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black),
      borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(choice, 
        style: TextStyle(
          fontSize: 30,
          //fontWeight: FontWeight.bold,
        ),)
      ],
    ),
  );


  void compareResult(BuildContext context, int index){

    if(vocabularyLabel == choicesList[index]){
      // Timer(Duration(milliseconds: 600), () {
        
      // });
      vocabularyPlayer.play("win.wav");
      Navigator.of(context).pushReplacementNamed('/vocabularyResultSuccess');
      //Navigator.of(context).popAndPushNamed('/vocabularyResultSuccess');
    } else {
      //Navigator.of(context).pushNamed('/vocabularyResultFailure');
      // Timer(Duration(milliseconds: 600), () {
        
      // });
      vocabularyPlayer.play("lose.wav");
      Navigator.of(context).pushNamed('/vocabularyResultFailure');
    }
  }
}