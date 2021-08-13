import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ImageQuestion extends StatelessWidget {
  const ImageQuestion({ Key key, this.imageLabel, this.imageUrl, this.urlChoices }) : super(key: key);

  final String imageLabel;
  final String imageUrl;
  final List<String> urlChoices;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        showQuizLabel(imageLabel),
        showQuizImage(context, urlChoices),
      ],
    );
  }

  Widget showQuizImage(BuildContext context, List<String> urlChoices) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.68,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        itemCount: urlChoices.length,
        itemBuilder: (context, index){
          return showIndividualImage(context, urlChoices[index]);
      }),
    ),
  );

  Widget showIndividualImage(BuildContext context, String url) => Padding(
    padding: const EdgeInsets.all(12),
    child: Container(
      height: MediaQuery.of(context).size.height * 0.30,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(url), //Load image if image is selected
            fit: BoxFit.contain,
        ),
      ),
    ),
  );

  Widget showQuizLabel(String label) => Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Text("$label", 
        style: GoogleFonts.ibmPlexSans(
        fontSize: 32,
        fontWeight: FontWeight.w400,
        //fontStyle: FontStyle.italic,
        letterSpacing: .5,
      ),),
    );
  
}