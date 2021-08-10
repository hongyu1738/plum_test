import 'package:flutter/material.dart';
import 'package:plum_test/models/image.dart';
import 'package:plum_test/screens/home/home.dart';
import 'package:plum_test/screens/learn/camera.dart';
import 'package:plum_test/screens/quiz/vocabulary_quiz.dart';
import 'package:plum_test/screens/revision/revision.dart';
import 'package:plum_test/screens/settings/settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      routes: {
        '/camera' : (context) => Camera(),
        '/settings' : (context) => Settings(),
        '/revision' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(),
          builder: (context, child){
            return Revision();
          }
        ),
        '/vocabularyQuiz' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(), 
          builder: (context, child){
            return VocabularyQuiz();
          }
        ),
      },
    );
  }
}