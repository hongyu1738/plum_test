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

    vocabularyPlayer.loadAll(["win.wav", "lose.wav"]); //Preload sound for smoother plays

    return Column(
      children: [
        showQuestionImage(context, vocabularyUrl),
        buildGrid(context, choicesList, volume),
      ],
    );
  }

  //Show question image on top of screen
  Widget showQuestionImage(BuildContext context, String url) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.35,
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

  //Build grid to display answer choices
  Widget buildGrid(BuildContext context, List choices, double volume) => Padding(
    padding: EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 4/3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10), 
        itemCount: choices.length,
        itemBuilder: (context, index){
          return InkWell(
              onTap: () {
                compareResult(context, index, volume);
              },
              splashColor: Colors.orangeAccent,
              child: showQuestionChoices(choices[index])
          );
        }
      ),
    ),
  );

  //Build container to display answer choices in grid built
  Widget showQuestionChoices(String choice) => Container(
    padding: EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: hexColors('#f9a603'),
      border: Border.all(color: Colors.white, width: 0.1),
      borderRadius: BorderRadius.circular(15)
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(choice, 
        style: TextStyle(
          fontSize: 35,
          color: Colors.white,
        ),)
      ],
    ),
  );

  //Function to check if the answer choice chosen is correct
  //Play sound effect for feedback
  void compareResult(BuildContext context, int index, double volume){
    if(vocabularyLabel == choicesList[index]){
      vocabularyPlayer.play("win.wav", volume: volume);
      Navigator.of(context).pushReplacementNamed('/vocabularyResultSuccess');
    } else {
      vocabularyPlayer.play("lose.wav", volume: volume);
      Navigator.of(context).pushNamed('/vocabularyResultFailure');
    }
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }
}