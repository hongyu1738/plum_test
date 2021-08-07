import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

class VerticalView extends StatelessWidget {
  const VerticalView({ Key key, this.classResult, this.imageResult}) : super(key: key);
  final String classResult;
  final Map<String, dynamic> imageResult; 


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        //SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
          child: Text('$classResult',
            style: GoogleFonts.lato(
              fontSize: 32,
              fontWeight: FontWeight.w500,
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
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          width: 300,
          height: 300,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(imageUrl),
              fit: BoxFit.contain,
            )
          ),
          //child: Image.network(imageUrl, width: 300, height: 300),
        ),
      )
    );
  }
}