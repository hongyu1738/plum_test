import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalView extends StatelessWidget {
  const VerticalView({ Key key, this.classResult, this.imageResult}) : super(key: key);
  final String classResult;
  final Map<String, dynamic> imageResult; 

  @override
  Widget build(BuildContext context) { //Create a row for each instance of a class in classResult list
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        //SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Text('$classResult',
            style: GoogleFonts.ibmPlexSans(
              fontSize: 32,
              fontWeight: FontWeight.w400,
              letterSpacing: .5,
              //fontStyle: FontStyle.italic,
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30.0),
          child: SizedBox(
            height: 200,
            child: AnimationLimiter(
              child: ListView.builder(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: imageResult[classResult].length,
                itemBuilder: (context, index){
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(
                        child: HorizontalView(imageUrl: imageResult[classResult][index]),
                      ),
                    ),
                  );
                  //return HorizontalView(imageUrl: imageResult[classResult][index]);
                }),
            ),
          ),
        ),
      ],
    );
  }
}

class HorizontalView extends StatelessWidget {
  const HorizontalView({ Key key, this.imageUrl}) : super(key: key);
  final dynamic imageUrl;  

  @override
  Widget build(BuildContext context) { //Creates a container for each instance of an image url in imageResult map
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.contain,
          )
        ),
          //child: Image.network(imageUrl, width: 300, height: 300),
      )
    );
  }
}