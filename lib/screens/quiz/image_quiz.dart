import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:plum_test/layout/image_question.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:animate_do/animate_do.dart';

class ImageQuiz extends StatefulWidget {
  const ImageQuiz({ Key key }) : super(key: key);

  @override
  _ImageQuizState createState() => _ImageQuizState();
}

class _ImageQuizState extends State<ImageQuiz> {

  void initState() {
    super.initState();
    context.read<ImageData>().fetchImageQuizData;
    context.read<ImageData>().fetchVolumeData;
    context.read<ImageData>().fetchRateData;
    context.read<ImageData>().fetchSfxVolume;
  }

  final imagePlayer = AudioCache(prefix: 'assets/audio/');

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Image Quiz',
        style: TextStyle(
          fontSize: 30,
          fontWeight: FontWeight.w400,
          letterSpacing: .5,
        )),
      ),

      body: BounceInDown(
        child: LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 500,
          showChildOpacityTransition: false,
          animSpeedFactor: 1.5,
          color: Colors.orangeAccent,
          onRefresh: () async {
            await context.read<ImageData>().fetchImageQuizData;
            await context.read<ImageData>().fetchVolumeData;
            await context.read<ImageData>().fetchRateData;
            await context.read<ImageData>().fetchSfxVolume;
          },
          child: SingleChildScrollView(
            child: Center(
              child: Consumer<ImageData>(
                builder: (context, value, child){
                  return (value.vocabularyImageLabel == '' && value.vocabularyImageUrl == '' && !value.vocabularyError) 
                  ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                  : value.vocabularyError ? 
                  SizedBox(
                    height: 500,
                    child: Center(
                      child: Text('Oops. \n${value.vocabularyErrorMessage}',
                      //Error message when vocabularyError == true
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w400,
                      ), )
                    )
                  )
                  : value.vocabularyImageLabel == '' && value.vocabularyImageUrl != ''
                  //Load circular progress indicator when fetching data for vocabularyImageLabel
                  ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                  : value.vocabularyImageLabel != '' && value.vocabularyImageUrl == ''
                  //Load circular progress indicator when fetching data for vocabularyImageUrl
                  ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                  : ImageQuestion(imageLabel: value.vocabularyImageLabel, imageUrl: value.vocabularyImageUrl, 
                  urlChoices: value.urlChoices, imagePlayer: imagePlayer,
                  volume: value.ttsVolume, rate: value.ttsRate, sfxVolume: value.sfxVolume);
                }
              )
            ),
          )
        ),
      ),
    );
  }
}