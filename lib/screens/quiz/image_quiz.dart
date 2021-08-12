import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image.dart';

class ImageQuiz extends StatefulWidget {
  const ImageQuiz({ Key key }) : super(key: key);

  @override
  _ImageQuizState createState() => _ImageQuizState();
}

class _ImageQuizState extends State<ImageQuiz> {

  @override
  Widget build(BuildContext context) {

    context.read<ImageData>().fetchRandomAnswer;

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

      body: RefreshIndicator(
        onRefresh: () async {},
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
              : Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text("${value.vocabularyImageLabel}", 
                      style: GoogleFonts.ibmPlexSans(
                      fontSize: 32,
                      fontWeight: FontWeight.w400,
                      //fontStyle: FontStyle.italic,
                      letterSpacing: .5,
                    ),),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.35,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(value.vocabularyImageUrl), //Load image if image is selected
                            fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  )
                ],
              );
            }
          )
        )
      ),
    );
  }
}