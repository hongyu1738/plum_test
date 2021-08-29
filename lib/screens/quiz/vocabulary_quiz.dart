import 'package:flutter/material.dart';
import 'package:plum_test/layout/vocabulary_question.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:provider/provider.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({ Key key }) : super(key: key);

  @override
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {

  void initState() {
    super.initState();
    context.read<ImageData>().fetchRandomAnswer;
  }

  final vocabularyPlayer = AudioCache(prefix: 'assets/audio/');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Vocabulary Quiz',
        style: TextStyle(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 30,
          fontWeight: FontWeight.w400,
          letterSpacing: .5,
          //fontStyle: FontStyle.italic,
        )),
        // titleTextStyle: TextStyle(
        //   fontSize: 24.0,
        // ),
      ),

      body: BounceInDown(
        child: LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 500,
          showChildOpacityTransition: false,
          animSpeedFactor: 1.5,
          color: Colors.orangeAccent,
          onRefresh: () async {
            await context.read<ImageData>().fetchRandomAnswer;
          },
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()
            ),
            child: Center(
              child: Consumer<ImageData>(
                  builder: (context, value, child){
                    return (value.vocabularyImageLabel == '' && value.vocabularyImageUrl == '' && !value.vocabularyError)
                    && (value.choiceResults.length == 0 && value.answerChoices.length == 0 && !value.choiceError)
                    ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator())) 
                    : value.vocabularyError ? SizedBox(
                      height: 500,
                      child: Center(
                        child: Text('Oops. \n${value.vocabularyErrorMessage}',
                        //Error message when vocabularyError == true
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          //textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 32,
                          fontWeight: FontWeight.w400,
                          //fontStyle: FontStyle.italic,
                          //letterSpacing: .5,
                        ), ),
                      ),
                    )
                    : value.choiceError ? Text('Oops. \n${value.choiceErrorMessage}',
                    //Error message when choiceError == true
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      //textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      //letterSpacing: .5,
                    ), )
                    : value.choiceResults.length != 0 && value.answerChoices.length == 0
                    //Load circular progress indicator when fetching data for answerChocies
                    ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                    : value.choiceResults.length == 0 && value.answerChoices.length != 0
                    //Load circular progress indicator when fetching data for choiceResults
                    ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                    : value.vocabularyImageLabel == '' && value.vocabularyImageUrl != ''
                    //Load circular progress indicator when fetching data for vocabularyImageLabel
                    ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                    : value.vocabularyImageLabel != '' && value.vocabularyImageUrl == ''
                    //Load circular progress indicator when fetching data for vocabularyImageUrl
                    ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                    : VocabularyQuestion(vocabularyLabel: value.vocabularyImageLabel, vocabularyUrl: value.vocabularyImageUrl,
                    choicesList: value.answerChoices, vocabularyPlayer: vocabularyPlayer);
                  },
                )
            ),
          ),
        ),
      ),
    );
  }
}

