import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:plum_test/models/image.dart';
import 'package:provider/provider.dart';

class VocabularyQuiz extends StatefulWidget {
  const VocabularyQuiz({ Key key }) : super(key: key);

  @override
  _VocabularyQuizState createState() => _VocabularyQuizState();
}

class _VocabularyQuizState extends State<VocabularyQuiz> {

  @override
  Widget build(BuildContext context) {

    //context.read<ImageData>().fetchImageData;
    //context.read<ImageData>().fetchClassData;
    context.read<ImageData>().fetchRandomImage;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Vocabulary Quiz',
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
        onRefresh: () async {
          await context.read<ImageData>().fetchRandomImage;
        },
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()
          ),
          child: Center(
            child: Consumer<ImageData>(
                builder: (context, value, child){
                  return (value.randomImageLabel == '' && value.randomImageUrl == '' && !value.randomError)
                  ? CircularProgressIndicator() 
                  : value.randomError ? Text('Oops. Something went wrong. \n${value.randomErrorMessage}',
                  //Error message when randomError == true
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ibmPlexSans(
                    //textStyle: Theme.of(context).textTheme.headline4,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    //fontStyle: FontStyle.italic,
                    //letterSpacing: .5,
                  ), )
                  : value.randomImageLabel == '' && value.randomImageUrl != ''
                  //Load circular progress indicator when fetching data for randomImageLabel
                  ? CircularProgressIndicator()
                  : value.randomImageLabel != '' && value.randomImageUrl == ''
                  //Load circular progress indicator when fetching data for randomImageUrl
                  ? CircularProgressIndicator()
                  : Column(
                    children: [
                      SizedBox(height: 30),
                      Center(
                      child: Container(
                        height: 350,
                        width: 350,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: NetworkImage(value.randomImageUrl), //Load image if image is selected
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ),
                    ],
                  );
                },
              )
          ),
        ),
      ),
    );
  }
}