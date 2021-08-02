import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
//import 'package:path_provider/path_provider.dart';
//import 'package:meta/meta.dart';
import 'package:tflite/tflite.dart';
import 'package:flutter_tts/flutter_tts.dart';

class Camera extends StatefulWidget {

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  //Instantiate image object
  final imagePicker = ImagePicker();

  //Instantiate classification model
  final FlutterTts flutterTts = FlutterTts();

  //Instantiate Firebase Storage
  final _storage = FirebaseStorage.instance;

  //Create an image object
  File _image;

  //List to store results from model
  List _result;

  //String to indicate class label of the image
  String _label;

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

        _storage.ref().child("$_label").child(image.path).putFile(_image); 
        //Save image to Cloud Storage with class label and image path

      } else {
        _image = null;
      }

    } else {
      print ("Camera permission not granted. Please try again.");
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

        _storage.ref().child("$_label").child(image.path).putFile(_image);
        //Save image to Cloud Storage with class label and image path

      } else {
        _image = null;
      }

    } else {
      print("Gallery permission not granted. Please try again.");
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
      _label = labels.substring(2); //Assign class labels to _label variable

    });
  }

  getSpeech() async { //Function for text to speech without customization
      await flutterTts.speak(_label);
  }

  @override
  void initState() { //Load image classification model on screen initialization
    super.initState();
    loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Learn'),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
        ),
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
                    child: Text('Select an image from the right bottom corner', //Text if no image is selected
                    textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 24),
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
                      flex: 2,
                      child: Center(
                        child: Text("$_label",
                          style: TextStyle(
                            fontSize: 30
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
                        iconSize: 40,
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
      
      // body: Padding(
      //   padding: const EdgeInsets.fromLTRB(0, 50.0, 0, 0),
      //   child: Align(
      //     alignment: Alignment.topCenter,
      //     child: Container(
      //       child: _image == null ? Center(
      //         child: Container(
      //           height: 350,
      //           width: 350,
      //           child: Text('Select an image from the right bottom corner', 
      //             textAlign: TextAlign.center,
      //             style: TextStyle(
      //             fontSize: 18)
      //             ) ,
      //           )
      //         )
      //         : Center(child: Container(
      //           height: 350,
      //           width: 350,
      //           decoration: BoxDecoration(image: DecorationImage(
      //             image: FileImage(_image),
      //             fit: BoxFit.contain,
      //               )
      //             ),
      //           )
      //         )
      //     ),
      //   ),
      // ),

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
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20.0),
              labelBackgroundColor: Colors.orange[400]
          ),

          SpeedDialChild(
              child: Icon(Icons.photo),
              backgroundColor: Colors.white,
              onTap: getImageFromGallery,
              label: 'Gallery',
              labelStyle: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 20.0),
              labelBackgroundColor: Colors.orange[400]
          ),
        ],
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return SpeedDial(
  //     animatedIcon: AnimatedIcons.menu_close,
  //     animatedIconTheme: IconThemeData(size: 22),
  //     backgroundColor: Colors.purple[800],
  //     visible: true,
  //     curve: Curves.bounceIn,
  //     children: [
  //       SpeedDialChild(
  //         child: Icon(Icons.camera_alt),
  //         backgroundColor: Colors.white,
  //         onTap: getImageFromCamera,
  //         label: 'Camera',
  //         labelStyle: TextStyle(
  //           fontWeight: FontWeight.w500,
  //           color: Colors.white,
  //           fontSize: 16.0),
  //         labelBackgroundColor: Colors.purple[800]
  //       ),
  //
  //       SpeedDialChild(
  //           child: Icon(Icons.photo),
  //           backgroundColor: Colors.white,
  //           onTap: getImageFromGallery,
  //           label: 'Gallery',
  //           labelStyle: TextStyle(
  //               fontWeight: FontWeight.w500,
  //               color: Colors.white,
  //               fontSize: 16.0),
  //           labelBackgroundColor: Colors.purple[800]
  //       ),
  //     ],
  //   );
  // }

}