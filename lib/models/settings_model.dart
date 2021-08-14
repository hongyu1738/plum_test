// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/foundation.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// //import 'dart:math';

// class SettingsData with ChangeNotifier{

//   double _ttsvolume = 0.5;
//   bool _ttsError = false;
//   String _ttsErrorMessage = "";

//   double get ttsvolume => _ttsvolume;
//   bool get ttsError => _ttsError;
//   String get ttsErrorMessage => _ttsErrorMessage;

//   Future <void> get fetchVolumeData async {
//     DocumentSnapshot ttsSnapshot = await FirebaseFirestore.instance.collection('Tts').doc('0').get();

//     if (ttsSnapshot.exists){
//       try {
//         _ttsvolume = ttsSnapshot['volume'];

//       } catch(e) {
//         _ttsError = true;
//         _ttsErrorMessage = e.toString();
//         _ttsvolume = 0;
//       }
//     } else {
//       _ttsError = true;
//       _ttsErrorMessage = "There is no specified volume. Please try again.";
//       _ttsvolume = 0;
//     } 
//   }

// }