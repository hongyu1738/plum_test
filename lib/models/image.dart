import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ImageData with ChangeNotifier {

  //Initialization of variables

  //Class data for revision.dart
  List <dynamic> _classResults = [];
  Map<String, dynamic> _classMap = {};
  bool _classError = false;
  String _classErrorMessage = '';

  //Image data for revision.dart
  Map<String, List> _imageResults = {};
  Map<String, dynamic> _imageMap = {};
  bool _imageError = false;
  String _imageErrorMessage = '';

  //Question data for vocabulary_quiz.dart
  int _imageCounter = 0; //Variable to count number of documents in Images collection
  int _randomNum = 0; //Variable to store random number generated through imageCounter as max
  String _vocabularyImageUrl = ''; //Variable to store image url from Images collection
  String _vocabularyImageLabel = ''; //Variable to store correct image label from Images collection
  bool _vocabularyError = false;
  String _vocabularyErrorMessage = '';

  //Choices data for vocabulary_quiz.dart
  List<dynamic> _choiceResults = []; //List to store all possible choices
  Map<String, dynamic> _choiceMap = {};
  bool _choiceError = false;
  String _choiceErrorMessage = '';
  List<String> _answerChoices = []; //List to store randomized choices

  List<String> _urlList = [];
  List<String> _urlChoices = [];

   Map<String, String> _dragMap = {};
   bool _dragError = false;
   String _dragErrorMessage = '';

  //Getter functions for variables

  List <dynamic> get classResults => _classResults;
  Map<String,dynamic> get classMap => _classMap;
  bool get classError => _classError;
  String get classErrorMessage => _classErrorMessage;

  Map<String, dynamic> get imageResults => _imageResults;
  Map<String, dynamic> get imageMap => _imageMap;
  bool get imageError => _imageError;
  String get imageErrorMessage => _imageErrorMessage;

  String get vocabularyImageLabel => _vocabularyImageLabel;
  String get vocabularyImageUrl => _vocabularyImageUrl;
  bool get vocabularyError => _vocabularyError;
  String get vocabularyErrorMessage => _vocabularyErrorMessage;

  List <dynamic> get choiceResults => _choiceResults;
  Map<String, dynamic> get choiceMap => _choiceMap;
  bool get choiceError => _choiceError;
  String get choiceErrorMessage => _choiceErrorMessage;
  List <String> get answerChoices => _answerChoices;

  List<String> get urlList => _urlList;
  List<String> get urlChoices => _urlChoices;

  Map<String, String> get dragMap => _dragMap;
  //List<String> get dragList => _dragList;
  bool get dragError => _dragError;
  String get dragErrorMessage => _dragErrorMessage;

  Future<void> get fetchImageData async { //Function to fetch image data from Cloud Firestore
    QuerySnapshot imageSnapshot = await FirebaseFirestore.instance.collection('Images').get();
    List<DocumentSnapshot<Object>> imageDocuments = imageSnapshot.docs;
    _imageResults.clear();
    _urlList.clear();
    _imageCounter = 0;

    if (imageDocuments.isNotEmpty){
      try {
        for (var doc in imageDocuments){
          _imageMap = doc.data(); //Map field and values of each document to _ImageMap
          var label = _imageMap['label']; //Acquire values of key 'label'
          var url = _imageMap['url']; //Acquire values of key 'url'
          _urlList.add(url);
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
    //print(_urlList);
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

  Future<void> get fetchChoicesData async { //Function to fetch all possible choices of answer from Cloud Firestore
    QuerySnapshot choiceSnapshot = await FirebaseFirestore.instance.collection('Answer').get();
    List<DocumentSnapshot<Object>> choiceDocuments = choiceSnapshot.docs;
    _choiceResults.clear();

    if (choiceDocuments.isNotEmpty){
      try {
        for (var doc in choiceDocuments){ 
          _choiceMap = doc.data(); 
          var answer = _choiceMap['answer']; 
          _choiceResults.add(answer);
        }
        _choiceError = false;
      } catch (e) {
        _choiceError = true;
        _choiceErrorMessage = "Something went wrong.\n" + e.toString();
        _choiceMap = {};
      }
    } else {
      _choiceError = true;
      _choiceErrorMessage = "There are no images found. Take an image to get started!";
      _choiceMap = {};
    }

    notifyListeners(); 
    //print(_answerResults);
  }

  Future<void> get fetchRandomAnswer async { //Function to fetch randomized answer chocies for Vocabulary Quiz

    await fetchChoicesData;
    await fetchVocabularyImage;

    _answerChoices.clear();
    _answerChoices.add(_vocabularyImageLabel);

    for (var i = 1; i < 4; i++){
      generateRandomNumber(50);
      String ans = _choiceResults[_randomNum];

      if (_answerChoices.contains(ans)){
        i--;
      } else {
        _answerChoices.add(ans);
      }
    }
    _answerChoices.shuffle();

    notifyListeners();
    //print(_answerChoices);
  }

  Future<void> get fetchVocabularyImage async { //Function to fetch a random image as question for Vocabulary Quiz

    await fetchImageData;
    //await fetchClassData;

    generateRandomNumber(_imageCounter);
    String rand = _randomNum.toString();
    DocumentSnapshot vocabularySnapshot = await FirebaseFirestore.instance.collection('Images').doc('$rand').get();

    if (vocabularySnapshot.exists){
      try {
        _vocabularyImageLabel = vocabularySnapshot['label'];
        _vocabularyImageUrl = vocabularySnapshot['url'];
        _vocabularyError = false;
      } catch (e) {
        _vocabularyError = true;
        _vocabularyErrorMessage = e.toString();
        _vocabularyImageLabel = '';
        _vocabularyImageUrl = '';
      }
    } else {
      _vocabularyError = true;
      _vocabularyErrorMessage = "There are no images found. Take an image to get started!";
      _vocabularyImageLabel = '';
      _vocabularyImageUrl = '';
    }

    notifyListeners();
    print(_vocabularyImageUrl);
    print(_vocabularyImageLabel);
  }

  Future<void> get fetchDragData async {

    await fetchImageData;
    _dragMap.clear();
    //_dragList.clear();

    for (var i = 1; i < 4; i++){
      generateRandomNumber(_imageCounter);
      String rand = _randomNum.toString();
      DocumentSnapshot dragSnapshot = await FirebaseFirestore.instance.collection('Images').doc('$rand').get();

      if (dragSnapshot.exists){
        try {
          String tempLabel = dragSnapshot['label'];
          String tempUrl = dragSnapshot['url'];

          if (dragMap.containsKey(tempLabel)){
            dragMap.update(tempLabel, (value) => tempUrl, ifAbsent: () => tempUrl);
            i--;
          } else {
            dragMap[tempLabel] = tempUrl;
          }
          _dragError = false;

        } catch (e) {
          _dragError = true;
          _dragErrorMessage = "Something went wrong.\n" + e.toString();
          _dragMap = {};
        }
      } else {
        _dragError = true;
        _dragErrorMessage = "There are no images found. Take an image to get started!";
        _dragMap = {};
      }
    }

    notifyListeners();
    print(_dragMap);
  }

  Future<void> get fetchImageQuizData async {

    await fetchVocabularyImage;
    
    _urlChoices.clear();
    _urlChoices.add(vocabularyImageUrl);

    for (var i = 1; i < 2; i++){
      generateRandomNumber(_imageCounter);
      String url = _urlList[_randomNum];

      if (_urlChoices.contains(url)){
        i--;
      } else {
        _urlChoices.add(url);
      }
    }

    _urlChoices.shuffle();
    notifyListeners();
    print(_urlChoices);
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