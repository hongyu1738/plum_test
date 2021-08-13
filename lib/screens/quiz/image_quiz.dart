import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plum_test/layout/image_question.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';
import 'package:animate_do/animate_do.dart';

class ImageQuiz extends StatefulWidget {
  const ImageQuiz({ Key key }) : super(key: key);

  @override
  _ImageQuizState createState() => _ImageQuizState();
}

class _ImageQuizState extends State<ImageQuiz> {

  @override
  Widget build(BuildContext context) {

    context.read<ImageData>().fetchImageQuizData;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Image Quiz',
        style: GoogleFonts.ibmPlexSans(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 26,
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
            await context.read<ImageData>().fetchImageQuizData;
          },
          child: SingleChildScrollView(
            child: Center(
              child: Consumer<ImageData>(
                builder: (context, value, child){
                  return (value.vocabularyImageLabel == '' && value.vocabularyImageUrl == '' && !value.vocabularyError) 
                  ? CircularProgressIndicator()
                  : value.vocabularyError ? Text('Oops. \n${value.vocabularyErrorMessage}',
                  //Error message when vocabularyError == true
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                    //textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    //fontStyle: FontStyle.italic,
                    //letterSpacing: .5,
                  ), )
                  : value.vocabularyImageLabel == '' && value.vocabularyImageUrl != ''
                  //Load circular progress indicator when fetching data for vocabularyImageLabel
                  ? CircularProgressIndicator()
                  : value.vocabularyImageLabel != '' && value.vocabularyImageUrl == ''
                  //Load circular progress indicator when fetching data for vocabularyImageUrl
                  ? CircularProgressIndicator()
                  : ImageQuestion(imageLabel: value.vocabularyImageLabel, imageUrl: value.vocabularyImageUrl, urlChoices: value.urlChoices);
                }
              )
            ),
          )
        ),
      ),
    );
  }
}