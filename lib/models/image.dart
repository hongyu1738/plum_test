import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageData with ChangeNotifier {

  Map<String, List> _imageResults = {};
  List <dynamic> _classResults = [];

  Map<String, dynamic> _classMap = {};
  bool _classError = false;
  String _classErrorMessage = '';

  Map<String, dynamic> _imageMap = {};
  bool _imageError = false;
  String _imageErrorMessage = '';

  Map<String,dynamic> get imageResults => _imageResults;
  List <dynamic> get classResults => _classResults;

  Map<String,dynamic> get classMap => _classMap;
  bool get classError => _classError;
  String get classErrorMessage => _classErrorMessage;

  Map<String,dynamic> get imageMap => _imageMap;
  bool get imageError => _imageError;
  String get imageErrorMessage => _imageErrorMessage;
  

  Future<void> get fetchImageData async {
    QuerySnapshot imageSnapshot = await FirebaseFirestore.instance.collection('Images').get();
    List<DocumentSnapshot<Object>> imageDocuments = imageSnapshot.docs;
    _imageResults.clear();

    if (imageDocuments.isNotEmpty){
      try {
        for (var doc in imageDocuments){
          _imageMap = doc.data();
          var label = _imageMap['label'];
          var url = _imageMap['url'];
          _imageResults.update(label, (urlList) => urlList..add(url), ifAbsent: () => [url]);
        }
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
  }

  Future<void> get fetchClassData async {
    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection('Class').get();
    List<DocumentSnapshot<Object>> classDocuments = classSnapshot.docs; 
    _classResults = [];

    if (classDocuments.isNotEmpty){
      try {
        for (var doc in classDocuments){
          _classMap = doc.data();
          var label = _classMap['label'];
          _classResults.add(label);
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
    notifyListeners();
    print(_classResults);
  }
  
  void initialImageValue(){
    _imageMap = {};
    _imageError = false;
    _imageErrorMessage = '';
    notifyListeners();
  }

  void initialClassValue(){
    _classMap = {};
    _classError = false;
    _classErrorMessage = '';
    notifyListeners();
  }
}