import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image.dart';
import 'package:plum_test/layout/view.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class Revision extends StatefulWidget {

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  @override
  Widget build(BuildContext context) {

    context.read<ImageData>().fetchImageData;
    context.read<ImageData>().fetchClassData;
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Revision',
        style: GoogleFonts.lato(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 26,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
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
              return (value.classMap.length == 0 && !value.classError)
              && (value.imageMap.length == 0 && !value.imageError) 
              ? CircularProgressIndicator() 
              : value.classError ? Text('Something went wrong when fetching class data. ${value.classErrorMessage}',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                //textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                letterSpacing: .5,
              ), )
              : value.imageError ? Text('Something went wrong when fetching image data. ${value.imageErrorMessage}',
              textAlign: TextAlign.center,
              style: GoogleFonts.lato(
                //textStyle: Theme.of(context).textTheme.headline4,
                fontSize: 24,
                fontWeight: FontWeight.w500,
                fontStyle: FontStyle.italic,
                letterSpacing: .5,
              ), )
              : value.classMap.length == 0 && value.imageMap.length != 0 
              ? CircularProgressIndicator()
              : value.imageMap.length == 0 && value.classMap.length != 0 
              ? CircularProgressIndicator()
              : AnimationLimiter(
                child: ListView.builder(
                  itemCount: value.classResults.length,
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
                    //return VerticalView(classResult: value.classResults[index], imageResult: value.imageResults);
                  }),
              );
            },
          )
        )  
      )
    );
  }
}
