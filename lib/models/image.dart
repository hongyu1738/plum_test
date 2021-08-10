import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class ImageData with ChangeNotifier {

  //Initialization of variables

  Map<String, List> _imageResults = {};
  List <dynamic> _classResults = [];

  Map<String, dynamic> _classMap = {};
  bool _classError = false;
  String _classErrorMessage = '';

  Map<String, dynamic> _imageMap = {};
  bool _imageError = false;
  String _imageErrorMessage = '';

  int _imageCounter = 0;
  int _randomNum = 0;
  String _randomImageUrl = '';
  String _randomImageLabel = '';
  bool _randomError = false;
  String _randomErrorMessage = '';

  //Getter functions for variables

  Map<String,dynamic> get imageResults => _imageResults;
  List <dynamic> get classResults => _classResults;

  Map<String,dynamic> get classMap => _classMap;
  bool get classError => _classError;
  String get classErrorMessage => _classErrorMessage;

  Map<String,dynamic> get imageMap => _imageMap;
  bool get imageError => _imageError;
  String get imageErrorMessage => _imageErrorMessage;

  String get randomImageLabel => _randomImageLabel;
  String get randomImageUrl => _randomImageUrl;
  bool get randomError => _randomError;
  String get randomErrorMessage => _randomErrorMessage;

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
        //generateRandomNumber(_imageCounter);
        _imageError = false;
      } catch (e) {
        _imageError = true;
        _imageErrorMessage = e.toString();
        _imageMap = {};
      }
    } else {
      _imageError = true;
      _imageErrorMessage = 'An unexpected error has arised. Please try again.';
      _imageMap = {};
    }

    notifyListeners();
    print(_imageResults);
    print(_imageCounter);
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
        _classErrorMessage = e.toString();
        _classMap = {};
      }
    } else {
      _classError = true;
      _classErrorMessage = 'An unexpected error has arised. Please try again.';
      _classMap = {};
    }

    _classResults.sort((a, b) => a.toString().compareTo(b.toString())); //Sort class results alphabetically
    notifyListeners(); 
    print(_classResults);
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
      _randomErrorMessage = 'Please try again.';
      _randomImageLabel = '';
      _randomImageUrl = '';
    }

    notifyListeners();
    print(_randomImageUrl);
    print(_randomImageLabel);
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