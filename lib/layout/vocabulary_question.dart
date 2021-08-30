import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class VocabularyQuestion extends StatelessWidget {
  const VocabularyQuestion({ Key key, this.vocabularyLabel, this.vocabularyUrl, this.choicesList, this.vocabularyPlayer, this.volume }) : super(key: key);

  final String vocabularyLabel;
  final String vocabularyUrl;
  final List<String> choicesList;
  final AudioCache vocabularyPlayer;
  final double volume;

  @override
  Widget build(BuildContext context) {

    vocabularyPlayer.loadAll(["win.wav", "lose.wav"]);

    return Column(
      children: [
        showQuestionImage(context, vocabularyUrl),
        buildGrid(context, choicesList, volume),
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

  Widget buildGrid(BuildContext context, List choices, double volume) => Padding(
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
              onTap: () => [compareResult(context, index, volume)],
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
        ),)
      ],
    ),
  );

  void compareResult(BuildContext context, int index, double volume){

    if(vocabularyLabel == choicesList[index]){
      vocabularyPlayer.play("win.wav", volume: volume);
      Navigator.of(context).pushReplacementNamed('/vocabularyResultSuccess');
    } else {
      vocabularyPlayer.play("lose.wav", volume: volume);
      Navigator.of(context).pushNamed('/vocabularyResultFailure');
    }
  }
}