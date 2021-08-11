import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image.dart';
import 'package:plum_test/layout/revision_vertical.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class Revision extends StatefulWidget {
  const Revision({ Key key }) : super(key: key);

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  @override
  Widget build(BuildContext context) {

    context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
    context.read<ImageData>().fetchClassData; //Fetch class data of type ClassData
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Revision',
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
          await context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
          await context.read<ImageData>().fetchClassData; //Fetch class data of type ClassData
        },
        child: Center(
          child: Consumer<ImageData>(
            builder: (context, value, child){
              return (value.classMap.length == 0 && !value.classError) //Check for availability of elements and errors for classMap
              && (value.imageMap.length == 0 && !value.imageError) //Check for availability of elements and errors for ImageMap
              ? CircularProgressIndicator() 
              : value.classError ? Text('Oops. ${value.classErrorMessage}',
              //Error message when classError == true
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                //textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                //fontStyle: FontStyle.italic,
                //letterSpacing: .5,
              ), )
              : value.imageError ? Text('Oops. ${value.imageErrorMessage}',
              //Error message when imageError == true
              textAlign: TextAlign.center,
              style: GoogleFonts.ibmPlexSans(
                //textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 24,
                fontWeight: FontWeight.w400,
                //fontStyle: FontStyle.italic,
                //letterSpacing: .5,
              ), )
              : value.classMap.length == 0 && value.imageMap.length != 0
              //Load circular progress indicator when fetching data for classMap
              ? CircularProgressIndicator()
              : value.imageMap.length == 0 && value.classMap.length != 0
              //Load circular progress indicator when fetching data for imageMap
              ? CircularProgressIndicator()
              : AnimationLimiter( //Show animation for display of class label and images
                child: ListView.builder(
                  itemCount: value.classResults.length, //Determine number of rows/total number of classes
                  itemBuilder: (context, index){
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                        verticalOffset: 50.0,
                        child: FadeInAnimation(
                          child: VerticalView(classResult: value.classResults[index], imageResult: value.imageResults),
                        ),
                      ),
                    );
                  }),
              );
            },
          )
        )  
      )
    );
  }
}
