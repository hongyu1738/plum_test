import 'package:flutter/material.dart';

class HorizontalView extends StatelessWidget {
  const HorizontalView({ Key key, this.imageUrl}) : super(key: key);
  final dynamic imageUrl;  

  @override
  Widget build(BuildContext context) { //Creates a container for each instance of an image url in imageResult map
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.white, width: 0.1),
          image: DecorationImage(
            image: NetworkImage(imageUrl),
            fit: BoxFit.contain,
          )
        ),
      )
    );
  }
}