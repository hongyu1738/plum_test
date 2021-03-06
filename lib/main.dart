import 'package:flutter/material.dart';
import 'package:plum_test/layout/drag_result_success.dart';
import 'package:plum_test/layout/image_result_failure.dart';
import 'package:plum_test/layout/image_result_success.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:plum_test/screens/home/home.dart';
import 'package:plum_test/screens/learn/camera.dart';
import 'package:plum_test/screens/login/login.dart';
import 'package:plum_test/screens/quiz/drag_n_drop.dart';
import 'package:plum_test/screens/quiz/image_quiz.dart';
import 'package:plum_test/screens/quiz/vocabulary_quiz.dart';
import 'package:plum_test/layout/vocabulary_result_failure.dart';
import 'package:plum_test/layout/vocabulary_result_success.dart';
import 'package:plum_test/screens/revision/revision.dart';
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
      theme: ThemeData(fontFamily: 'MouseMemoirs'),
      routes: {
        '/' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(),
          builder: (context,child){
            return LoginPage();
          }
        ),
        '/home' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(),
          builder: (context,child){
            return Home();
          }
        ),
        '/camera' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(), 
          builder: (context, child){ 
            return Camera(); 
          }
        ),
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
        '/imageQuiz' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(), 
          builder: (context, child){
            return ImageQuiz();
          }
        ),
        '/vocabularyResultSuccess' : (context) => VocabularyResultSuccess(),
        '/vocabularyResultFailure' : (context) => VocabularyResultFailure(),
        '/imageResultSuccess' : (context) => ImageResultSuccess(),
        '/imageResultFailure' : (context) => ImageResultFailure(),
        '/dragQuiz' : (context) => ChangeNotifierProvider(
          create: (context) => ImageData(), 
          builder: (context, child){
            return DragAndDrop();
          }
        ),
        '/dragResultSuccess' : (context) => DragResultSuccess(),
      },
    );
  }
}