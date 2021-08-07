import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:meta/meta.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:toast/toast.dart';

class Camera extends StatefulWidget {

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  //Instantiate image object
  final ImagePicker imagePicker = ImagePicker();

  //Instantiate classification model
  final FlutterTts flutterTts = FlutterTts();

  //Instantiate Firebase Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Create an image object
  File _image;

  //List to store results from model
  List _result = [];

  //String to indicate class label of the image
  String _label = "";

  //Load image classification model on screen initialization
  @override
  void initState() { 
    super.initState();
    loadModel();
  }

  //Function to get image from Camera
  Future getImageFromCamera() async{
    
    //Get permission for Camera
    await Permission.camera.request();
    
    //Assign permission status to variable
    var cameraPermissionStatus = await Permission.camera.status;

    //Execute code for image accessibility from camera on permission granted
    if (cameraPermissionStatus.isGranted){

      //Access camera and get image from camera
      final image = await imagePicker.getImage(source: ImageSource.camera);

      //Assign image to image file if image is taken
      if (image != null){

        _image = File(image.path);

        await runModel(_image); //Classify image from camera

        GallerySaver.saveImage(image.path); //Save image to gallery

        addImageToStorage(_image);

      } else {
        _image = null;
        //print("No image");
        Toast.show("No image taken. Please try again.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }

    } else {
      //print ("Camera permission not granted. Please try again.");
      Toast.show("Camera permission not granted. Please try again.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //Function to get image from gallery
  Future getImageFromGallery() async{

    //Get permission for Gallery
    await Permission.storage.request();

    //Assign permission status to variable
    var photoPermissionStatus = await Permission.storage.status;

    //Execute code for image accessibility from camera on permission granted
    if (photoPermissionStatus.isGranted){

      //Access gallery and get image from gallery
      final image = await imagePicker.getImage(source: ImageSource.gallery);

      //Assign image to image file if image is selected
      if (image != null){

        _image = File(image.path);

        await runModel(_image); //Classify image from gallery

        addImageToStorage(_image);

      } else {
        _image = null;
        //print("No image");
        Toast.show("No image selected. Please try again.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      }

    } else {
      //print("Gallery permission not granted. Please try again.");
      Toast.show("Gallery permission not granted. Please try again.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
    }
  }

  //Function to upload images to Cloud Storage
  Future addImageToStorage(File image) async {

    String imagePath = image.path.split('/').last;

    //Set image path in Cloud Storage
    String imageLocation = "$_label/$imagePath";

    //Upload images to Cloud Storage
    await _storage.ref().child(imageLocation).putFile(image);

    addLocationToDatabase(imageLocation, imagePath);
  }

  //Function to upload download URL of images to Cloud Firestore
  Future addLocationToDatabase(String location, String imagePath) async {

    //Acquire storage reference of images through image path
    final ref = _storage.ref().child(location);

    //Acquire download URL of images through storage reference
    var locationString = await ref.getDownloadURL();

    List labelList = [];

    List urlList = [];

    QuerySnapshot imageSnapshot = await FirebaseFirestore.instance.collection("Images").get();

    for (var doc in imageSnapshot.docs){
      Map<String, dynamic> urlMap = doc.data();
      String url = urlMap['url'].toString();
      urlList.add(url);
    }

    if (urlList.contains(locationString)){
      Toast.show("The image already exists.", context, duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
      //print("URL exists.");
    } else {

      //Upload download URL of images to Cloud Firestore
      //await FirebaseFirestore.instance.collection("$_label").doc("$imagePath").set({'url' : locationString, 'label' : _label});

      int imageSnapshotSize = imageSnapshot.size;
      await FirebaseFirestore.instance.collection("Images").doc(imageSnapshotSize.toString()).set({ 'url' : locationString, 'label' : _label});
    }


    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection("Class").get();

    for (var doc in classSnapshot.docs) {
      Map<String, dynamic> labelMap = doc.data();
      String label = labelMap['label'].toString();
      labelList.add(label);
    }

    if (labelList.contains('$_label')){
      print("Element exists");
      //Toast.show("No image selected", context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
    } else {
      int classSnapshotSize = classSnapshot.size;
      await FirebaseFirestore.instance.collection("Class").doc(classSnapshotSize.toString()).set({'label' : _label});
    }
  }

  //Function for default loading of image classification model
  loadModel() async {

    var loadModelResult = await Tflite.loadModel(
      labels: "assets/labels.txt",
      model: "assets/model_unquant.tflite"
    );

    print("Result: $loadModelResult");
  }

  //Run image classification model for image selected
  runModel(File file) async {

    var runModelResult = await Tflite.runModelOnImage( 

      //Customization for display on threshold and number of results
      path: file.path,
      numResults: 50,
      threshold: 0.5,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _result = runModelResult; //Assign results to _result list variable

      String labels = _result[0]["label"]; //Assign class labels to labels variable
      _label = labels.substring(3); //Assign class labels to _label variable

    });
  }

  getSpeech() async { //Function for text to speech without customization
      await flutterTts.speak(_label);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Learn',
        style: GoogleFonts.lato(
          //textStyle: Theme.of(context).textTheme.headline4,
          fontSize: 26,
          fontWeight: FontWeight.w500,
          fontStyle: FontStyle.italic,
        )),
        // titleTextStyle: TextStyle(
        //   fontSize: 24.0,
        // ),
      ),
      body: Container(
        child: Column(
          children: [
            _image == null ? Column(
              children: [

                SizedBox(height: 200),

                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Text('Select an image from the right bottom corner',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.lato(
                      //textStyle: Theme.of(context).textTheme.headline4,
                      fontSize: 36,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                      letterSpacing: .5,
                    ), 
                    ),
                  ),
                ),
              ],
            )

            : Column(
              children: [
                SizedBox(height: 30),

                Center(
                  child: Container(
                    height: 350,
                    width: 350,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image), //Load image if image is selected
                        fit: BoxFit.scaleDown,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                Row(
                  children: [
                    Spacer(),

                    Expanded(
                      flex: 3,
                      child: Center(
                        child: Text("$_label",
                        style: GoogleFonts.lato(
                          //textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 40,
                          fontWeight: FontWeight.w500,
                          //fontStyle: FontStyle.italic,
                          letterSpacing: .5,
                        ), 
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: IconButton(
                        onPressed: getSpeech,
                        icon: Icon(Icons.volume_up_rounded),
                        color: Colors.grey[800],
                        iconSize: 44,
                        tooltip: "Press for pronounciation",
                      ),
                    ),

                    Spacer(),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: IconThemeData(size: 30),
        backgroundColor: Colors.orange[400],
        visible: true,
        curve: Curves.bounceIn,
        spaceBetweenChildren: 10.0,
        children: [
          SpeedDialChild(
              child: Icon(Icons.camera_alt),
              backgroundColor: Colors.white,
              onTap: getImageFromCamera,
              label: 'Camera',
              labelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic),
              labelBackgroundColor: Colors.orange[400]
          ),

          SpeedDialChild(
              child: Icon(Icons.photo),
              backgroundColor: Colors.white,
              onTap: getImageFromGallery,
              label: 'Gallery',
              labelStyle: GoogleFonts.lato(
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic),
              labelBackgroundColor: Colors.orange[400]
          ),
        ],
      ),
    );
  }
}