import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ImageData with ChangeNotifier {

  //Initialization of variables

  List <dynamic> _classResults = [];
  Map<String, dynamic> _classMap = {};
  bool _classError = false;
  String _classErrorMessage = '';

  Map<String, List> _imageResults = {};
  Map<String, dynamic> _imageMap = {};
  bool _imageError = false;
  String _imageErrorMessage = '';

  int _imageCounter = 0;
  int _randomNum = 0;
  String _randomImageUrl = '';
  String _randomImageLabel = '';
  bool _randomError = false;
  String _randomErrorMessage = '';

  List<dynamic> _answerResults = [];
  Map<String, dynamic> _answerMap = {};
  bool _answerError = false;
  String _answerErrorMessage = '';
  int _randomNumForAns = 0;
  List<String> _answerChoices = [];

  //Getter functions for variables

  List <dynamic> get classResults => _classResults;
  Map<String,dynamic> get classMap => _classMap;
  bool get classError => _classError;
  String get classErrorMessage => _classErrorMessage;

  Map<String,dynamic> get imageResults => _imageResults;
  Map<String,dynamic> get imageMap => _imageMap;
  bool get imageError => _imageError;
  String get imageErrorMessage => _imageErrorMessage;

  String get randomImageLabel => _randomImageLabel;
  String get randomImageUrl => _randomImageUrl;
  bool get randomError => _randomError;
  String get randomErrorMessage => _randomErrorMessage;

  List <dynamic> get answerResults => _answerResults;
  Map<String,dynamic> get answerMap => _answerMap;
  bool get answerError => _answerError;
  String get answerErrorMessage => _answerErrorMessage;
  List <String> get answerChoices => _answerChoices;

  Future<void> get fetchImageData async { //Function to fetch image data from Cloud Firestore
    QuerySnapshot imageSnapshot = await FirebaseFirestore.instance.collection('Images').get();
    List<DocumentSnapshot<Object>> imageDocuments = imageSnapshot.docs;
    _imageResults.clear();
    _imageCounter = 0;

    if (imageDocuments.isNotEmpty){
      try {
        for (var doc in imageDocuments){
          _imageMap = doc.data(); //Map field and values of each document to _ImageMap
          var label = _imageMap['label']; //Acquire values of key 'label'
          var url = _imageMap['url']; //Acquire values of key 'url'
          _imageResults.update(label, (urlList) => urlList..add(url), ifAbsent: () => [url]); //Add values of key 'label' and 'url' to _imageResults map
          _imageCounter++;
        }
        _imageError = false;
      } catch (e) {
        _imageError = true;
        _imageErrorMessage = "Something went wrong.\n" + e.toString();
        _imageMap = {};
      }
    } else {
      _imageError = true;
      _imageErrorMessage = "There are no images found. Take an image to get started!";
      _imageMap = {};
    }

    notifyListeners();
    //print(_imageResults);
    //print(_imageCounter);
  }

  Future<void> get fetchClassData async { //Function to fetch class data from Cloud Firestore
    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection('Class').get();
    List<DocumentSnapshot<Object>> classDocuments = classSnapshot.docs; 
    _classResults.clear();

    if (classDocuments.isNotEmpty){
      try {
        for (var doc in classDocuments){ 
          _classMap = doc.data(); //Map field and values of each document to _classMap
          var label = _classMap['label']; //Acquire values of key 'label'
          _classResults.add(label); //Add values of key 'label' to _classResults list
        }
        _classError = false;
      } catch (e) {
        _classError = true;
        _classErrorMessage = "Something went wrong.\n" + e.toString();
        _classMap = {};
      }
    } else {
      _classError = true;
      _classErrorMessage = "There are no images found. Take an image to get started!";
      _classMap = {};
    }

    _classResults.sort((a, b) => a.toString().compareTo(b.toString())); //Sort class results alphabetically
    notifyListeners(); 
    //print(_classResults);
  }

  Future<void> get fetchAnswerData async {
    QuerySnapshot answerSnapshot = await FirebaseFirestore.instance.collection('Answer').get();
    List<DocumentSnapshot<Object>> answerDocuments = answerSnapshot.docs;
    _answerResults.clear();

    if (answerDocuments.isNotEmpty){
      try {
        for (var doc in answerDocuments){ 
          _answerMap = doc.data(); 
          var answer = _answerMap['answer']; 
          _answerResults.add(answer);
        }
        _answerError = false;
      } catch (e) {
        _answerError = true;
        _answerErrorMessage = "Something went wrong.\n" + e.toString();
        _answerMap = {};
      }
    } else {
      _answerError = true;
      _answerErrorMessage = "There are no images found. Take an image to get started!";
      _answerMap = {};
    }

    notifyListeners(); 
    print(_answerResults);
  }

  Future<void> get fetchRandomAnswer async {

    await fetchAnswerData;

    _answerChoices.clear();
    _answerChoices.add(_randomImageLabel);

    for (var i = 1; i < 4; i++){
      generateRandomNumberForAnswer();
      String ans = _answerResults[_randomNumForAns];

      if (_answerChoices.contains(ans)){
        i--;
      } else {
        _answerChoices.add(ans);
      }
    }

    notifyListeners();
    print(_answerChoices);
  }

  Future<void> get fetchRandomImage async {

    await fetchImageData;
    await fetchClassData;

    generateRandomNumber(_imageCounter);
    String rand = _randomNum.toString();
    DocumentSnapshot randomSnapshot = await FirebaseFirestore.instance.collection('Images').doc('$rand').get();

    if (randomSnapshot.exists){
      try {
        _randomImageLabel = randomSnapshot['label'];
        _randomImageUrl = randomSnapshot['url'];
        _randomError = false;
      } catch (e) {
        _randomError = true;
        _randomErrorMessage = e.toString();
        _randomImageLabel = '';
        _randomImageUrl = '';
      }
    } else {
      _randomError = true;
      _randomErrorMessage = "There are no images found. Take an image to get started!";
      _randomImageLabel = '';
      _randomImageUrl = '';
    }

    notifyListeners();
    print(_randomImageUrl);
    print(_randomImageLabel);
  }

  void generateRandomNumberForAnswer(){
    Random random = new Random();
    _randomNumForAns = random.nextInt(50);
    notifyListeners();
  }
  
  void generateRandomNumber(int counter){
    Random random = new Random();
    _randomNum = random.nextInt(counter);
    notifyListeners();
  }

  void initialImageValue(){ //Function to reset image variables
    _imageMap = {};
    _imageError = false;
    _imageErrorMessage = '';
    notifyListeners();
  }

  void initialClassValue(){ //Function to reset class variables
    _classMap = {};
    _classError = false;
    _classErrorMessage = '';
    notifyListeners();
  }
}