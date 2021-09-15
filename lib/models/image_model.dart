import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

import 'package:plum_test/user.dart';

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
  String _tempUrl = '';

   Map<String, String> _dragMap = {};
   bool _dragError = false;
   String _dragErrorMessage = '';

  double _ttsVolume = 0.5;
  double _ttsRate = 1.0;
  bool _ttsError = false;
  String _ttsErrorMessage = "";

  double _bgVolume = 0.2;
  bool _bgError = false;
  String _bgErrorMessage = "";

  double _sfxVolume = 0.5;
  bool _sfxError = false;
  String _sfxErrorMessage = "";

  String _username = "";
  String _password = "";
  //String _uid = "";
  bool _uidError = false;
  String _uidErrorMessage = "";

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

  double get ttsVolume => _ttsVolume;
  double get ttsRate => _ttsRate;
  bool get ttsError => _ttsError;
  String get ttsErrorMessage => _ttsErrorMessage;

  double get bgVolume => _bgVolume;
  bool get bgError => _bgError;
  String get bgErrorMessage => _bgErrorMessage;

  double get sfxVolume => _sfxVolume;
  bool get sfxError => _sfxError;
  String get sfxErrorMessage => _sfxErrorMessage;

  String get username => _username;
  String get password => _password;
  //String get uid => _uid;
  bool get uidError => _uidError;
  String get uidErrorMessage => _uidErrorMessage;


  Future<void> get fetchImageData async { //Function to fetch image data from Cloud Firestore
    _username = User.username; 
    QuerySnapshot imageSnapshot = await FirebaseFirestore.instance.collection('Images').doc(_username).collection('Images').get();
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
    _username = User.username; 
    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection('Class').doc(_username).collection('Class').get();
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

  Future<void> get fetchChoicesData async { 
    //Function to fetch all possible choices of answer from Cloud Firestore
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

  Future<void> get fetchRandomAnswer async { 
    //Function to fetch randomized answer choices for Vocabulary Quiz

    await fetchChoicesData; //Fetch data for choiceResults
    await fetchVocabularyImage; //Fetch data for vocabularyImageLabel and vocabularyImageUrl

    _answerChoices.clear(); //Clear pre-existing image labels in answerChoices
    _answerChoices.add(_vocabularyImageLabel); //Add vocabularyImageLabel as answer

    for (var i = 1; i < 4; i++){ //Loop four times for four different answers
      //Generate random number with a max value of 29
      generateRandomNumber(30);
      //Acquire random answer from choiceResults
      String ans = _choiceResults[_randomNum];

      //If random answer is already in answerChoices, then rerun the loop
      if (_answerChoices.contains(ans)){
        i--;
      } else {
        // If not, add the answer to the answerChoices list
        _answerChoices.add(ans);
      }
    }
    _answerChoices.shuffle(); //Shuffle the list for randomization

    notifyListeners();
    //print(_answerChoices);
  }

  Future<void> get fetchVocabularyImage async { 
    //Function to fetch a random image and label as the question and answer

    await fetchImageData;
    _username = User.username; 

    if (_imageResults.keys.length < 2) {
      _vocabularyError = true;
      _vocabularyErrorMessage = "Unlock more classes to play the game! Classes required: ${(2 - _imageResults.keys.length)}";
      _vocabularyImageLabel = '';
      _vocabularyImageUrl = '';

    } else {
      //Generate a random number for random image label and url
      generateRandomNumber(_imageCounter);
      String rand = _randomNum.toString();
      DocumentSnapshot vocabularySnapshot = await FirebaseFirestore.instance.collection('Images').doc(_username).
      collection('Images').doc('$rand').get();

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
    }

    notifyListeners();
    //print(_vocabularyImageUrl);
    //print(_vocabularyImageLabel);
  }

  Future<void> get fetchDragData async {
    //Function to fetch data for Drag and Drop Quiz

    _username = User.username; 
    await fetchImageData; //Fetch data from Images
    _dragMap.clear(); //Clear pre-existing data from dragMap

    if (_imageResults.keys.length < 6) {
      _dragError = true;
      _dragErrorMessage = "Unlock more classes to play the game! Classes required: ${(6 - _imageResults.keys.length)}";
      _dragMap = {};
    } else {
      for (var i = 1; i < 4; i++){ //Run the loop three times for three image labels and url
        //Generate random number based on imageCounter
        generateRandomNumber(_imageCounter); 
        String rand = _randomNum.toString();
        DocumentSnapshot dragSnapshot = await FirebaseFirestore.instance.collection('Images').doc(_username).
        collection('Images').doc('$rand').get();

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
    }

    notifyListeners();
    //print(_dragMap);
  }

  Future<void> get fetchImageQuizData async { 
    //Function to fetch image data for Image Quiz

    await fetchVocabularyImage; //Fetch data for vocabularyImageLabel and vocabularyImageUrl
    await fetchClassData; //Fetch data from Class collection
    
    _urlChoices.clear(); //Clear pre-existing url from urlChoices
    _urlChoices.add(vocabularyImageUrl); //Add fetched vocabularyImageUrl to urlChoices as answer

    if (_classResults.length < 4) {
      _vocabularyError = true;
      _vocabularyErrorMessage = "Unlock more classes to play the game! Classes required: ${(4 - _classResults.length)}";
      _vocabularyImageLabel = '';
      _vocabularyImageUrl = '';
      
    } else {
      for (var i = 1; i < 2; i++){

        //Generate random number based on length of classResults
        generateRandomNumber(_classResults.length);
        //Generate a random temporary class with random number 
        String tempClass = _classResults[_randomNum];
        
        if (tempClass == vocabularyImageLabel){
          //Check if random temporary class is same to vocabularyImageLabel
          //If yes, then rerun the loop as the images belong to the same class
          i--;
        } else {
          //If no, then fetch image url from imageResults using the tempClass generated as key
          List <dynamic> tempList = _imageResults[tempClass];
          //Generate another random number to pick a random image url from the list value of imageResults
          generateRandomNumber(tempList.length);
          //Pick random image url from the list value of imageResults
          _tempUrl = tempList[_randomNum];
          //Add the image url as the second choice to urlChoices
          _urlChoices.add(_tempUrl);
        }
      }
      _urlChoices.shuffle(); // Shuffle the list for randomization
      _vocabularyError = false;
    }

    notifyListeners();
    //print(_urlChoices);
  }

  Future <void> get fetchVolumeData async {
    // Function to fetch data on pronunciation volume

    _username = User.username; 
    DocumentSnapshot ttsSnapshot = await FirebaseFirestore.instance.collection('Tts').doc(_username).get();

    if (ttsSnapshot.exists){
      try {
        _ttsVolume = ttsSnapshot['volume'];
        _ttsError = false;
        _ttsErrorMessage = 'No error';

      } catch(e) {
        _ttsError = true;
        _ttsErrorMessage = e.toString();
        _ttsVolume = 0.0;
      }
    } else {
      _ttsError = true;
      _ttsErrorMessage = "There is no specified volume. Please try again.";
      _ttsVolume = 0.0;
    } 

    notifyListeners();
  }

  Future <void> get fetchRateData async {
    // Function to fetch data on speech rate

    _username = User.username; 
    DocumentSnapshot ttsSnapshot = await FirebaseFirestore.instance.collection('Tts').doc(_username).get();

    if (ttsSnapshot.exists){
      try {
        _ttsRate = ttsSnapshot['rate'];
        _ttsError = false;

      } catch(e) {
        _ttsError = true;
        _ttsErrorMessage = e.toString();
        _ttsRate = 0.0;
      }
    } else {
      _ttsError = true;
      _ttsErrorMessage = "There is no specified rate. Please try again.";
      _ttsRate = 0.0;
    } 

    notifyListeners();
  }

  Future <void> get fetchBackgroundVolume async {
    
    _username = User.username; 
    DocumentSnapshot backgroundSnapshot = await FirebaseFirestore.instance.collection('Background').doc(_username).get();

    if (backgroundSnapshot.exists){
      try {
        _bgVolume = backgroundSnapshot['volume'];
        _bgError = false;

      } catch(e) {
        _bgError = true;
        _bgErrorMessage = e.toString();
        _bgVolume = 0.0;
      }
    } else {
      _bgError = true;
      _bgErrorMessage = "There is no specified volume. Please try again.";
      _bgVolume = 0.0;
    }

    notifyListeners();
    //print(_bgVolume);
  }

  Future <void> get fetchSfxVolume async {

    _username = User.username; 
    DocumentSnapshot sfxSnapshot = await FirebaseFirestore.instance.collection('Sfx').doc(_username).get();

    if (sfxSnapshot.exists){
      try {
        _sfxVolume = sfxSnapshot['volume'];
        _sfxError = false;

      } catch(e) {
        _sfxError = true;
        _sfxErrorMessage = e.toString();
        _sfxVolume = 0.0;
      }
    } else {
      _sfxError = true;
      _sfxErrorMessage = "There is no specified volume. Please try again.";
      _sfxVolume = 0.0;
    }

    notifyListeners();
  }

  Future <String> setRegisterData(String username, String password) async {
    _username = username;
    _password = password;

    await fetchRegisterData;

    return _uidErrorMessage;
  }

  Future <void> get fetchRegisterData async {
    DocumentSnapshot registerSnapshot = await FirebaseFirestore.instance.collection('User').doc(_username).get();

    if (registerSnapshot.exists){
      try {
        if (_password == registerSnapshot['password']){
          _uidError = false;
          _uidErrorMessage = "";
        } else {
          _uidError = true;
          _uidErrorMessage = "Invalid username or password. Please try again.";
        }
      } catch(e) {
        _uidError = true;
        _uidErrorMessage = e.toString();
      }
    } else {
      _uidError = true;
      _uidErrorMessage = "Invalid username or password. Please try again.";
    }
    
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