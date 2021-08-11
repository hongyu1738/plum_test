import 'package:flutter/material.dart';

class VocabularyQuestionLayout extends StatelessWidget {
  const VocabularyQuestionLayout({
    Key key,
    this.label,
    this.url,
    this.choices,
  }) : super(key: key);

  final String label;
  final String url;
  final List<String> choices;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 30),
        Center(
          child: Container(
            height: 350,
            width: 350,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(url), //Load image if image is selected
                fit: BoxFit.scaleDown,
              ),
            ),
          ),
        ),
        Text("$label"),
      ],
    );
  }
}