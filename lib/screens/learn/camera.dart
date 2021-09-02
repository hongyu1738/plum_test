import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plum_test/layout/camera_speech.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:tflite/tflite.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Camera extends StatefulWidget {
  const Camera({ Key key }) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  //Instantiate image object
  final ImagePicker imagePicker = ImagePicker();

  //Instantiate Firebase Storage
  final FirebaseStorage _storage = FirebaseStorage.instance;

  //Create an image object
  File _image;

  //List to store results from model
  List _result = [];

  //String to indicate class label of the image
  String _label;

  //Double to store confidence level of class labels
  double _confidence;

  //Load image classification model on screen initialization
  @override
  void initState() { 
    super.initState();
    loadModel();
    context.read<ImageData>().fetchVolumeData;
    context.read<ImageData>().fetchRateData;
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

        if (_confidence > 0.9){ 

        //Add image to Cloud Firestore and Gallery only when confidence level of class label > 0.9
          
          GallerySaver.saveImage(image.path); //Save image to gallery

          addImageToStorage(_image);
        }

      } else {
        _image = null;

        Fluttertoast.showToast(
          msg: "No image taken.\nPlease try again.", 
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          fontSize: 22.0,
          backgroundColor: Colors.black54,
          textColor: Colors.white
        );
      }

    } else {

      Fluttertoast.showToast(
        msg: "Camera permission not granted.\nPlease try again.", 
        toastLength: Toast.LENGTH_LONG, 
        gravity: ToastGravity.BOTTOM,
        fontSize: 22.0,
        backgroundColor: Colors.black54,
        textColor: Colors.white
      );

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

        if (_confidence > 0.9){

        //Add image to Cloud Firestore only when confidence level of class label > 0.9

          addImageToStorage(_image);
        }

      } else {
        _image = null;

        Fluttertoast.showToast(
          msg: "No image selected.\nPlease try again.", 
          toastLength: Toast.LENGTH_LONG, 
          gravity: ToastGravity.BOTTOM,
          fontSize: 22.0,
          backgroundColor: Colors.black54,
          textColor: Colors.white
        );

      }

    } else {

      Fluttertoast.showToast(
        msg: "Gallery permission not granted.\nPlease try again.", 
        toastLength: Toast.LENGTH_LONG, 
        gravity: ToastGravity.BOTTOM,
        fontSize: 22.0,
        backgroundColor: Colors.black54,
        textColor: Colors.white
      );

    }
  }

  Future cropImage() async { //Function to manage cropping of image

    File croppedFile = await ImageCropper.cropImage(
      sourcePath: _image.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.original,
      ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Crop',
        toolbarColor: Colors.orange[400],
        backgroundColor: Colors.white,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      )
    );

    if (croppedFile != null){

      setState(() {
        _image = croppedFile;
      });

      await runModel(_image);

      if (_confidence > 0.9){
        addImageToStorage(_image);
      }
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

      Fluttertoast.showToast(
        msg: "The image already exists.", 
        toastLength: Toast.LENGTH_LONG, 
        gravity: ToastGravity.BOTTOM,
        fontSize: 22.0,
        backgroundColor: Colors.black54,
        textColor: Colors.white
      );

    } else {

      //Upload download URL of images to Cloud Firestore

      int imageSnapshotSize = imageSnapshot.size;
      await FirebaseFirestore.instance.collection("Images").doc(imageSnapshotSize.toString()).set({ 'url' : locationString, 'label' : _label});
    }


    QuerySnapshot classSnapshot = await FirebaseFirestore.instance.collection("Class").get();

    for (var doc in classSnapshot.docs) {
      Map<String, dynamic> labelMap = doc.data();
      String label = labelMap['label'].toString();
      labelList.add(label);
    }

    if (!labelList.contains('$_label')){
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
      threshold: 0.1,
      imageMean: 127.5,
      imageStd: 127.5,
    );

    setState(() {
      _result = runModelResult; //Assign results to _result list variable

      String labels = _result[0]["label"]; //Assign class labels to labels variable
      _label = labels.substring(3); //Assign class labels to _label variable 

      //Set confidence level of image to 0.2, if image classification is below passing thresholds
      _confidence = _result != null ? (_result[0]["confidence"]) : 0.1 ;

      //Show alert dialog if confidence level is below passing thresholds
      if (_confidence < 0.9){
        _alertDialog();
      }

    });
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Learn',
        style: TextStyle(
          fontSize: 30,
          letterSpacing: .5,
        )),
      ),

      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            _image == null ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
               SizedBox(height: 200),

                Center(
                  child: Container(
                    height: 300,
                    width: 300,
                    child: Text('Select an image from the right bottom corner',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
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
                  child: GestureDetector(
                    onTap: cropImage,
                    child: Container(
                      height: 350,
                      width: 350,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: FileImage(_image), //Load image if image is selected
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 40),

                _confidence < 0.9 ? Text('No classes found :(',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w400,
                    //letterSpacing: .5,
                  ), 
                )

                : Row(
                  children: [
                    Spacer(flex: 2),

                    Expanded(
                      flex: 7,
                      child: Center(
                        child: Text("$_label",
                          style: TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w400,
                            letterSpacing: .5,
                          ), 
                        ),
                      ),
                    ),

                    Spacer(),

                    Consumer<ImageData>(builder: (context, value, child){
                      return CameraSpeech(volume: value.ttsVolume, rate: value.ttsRate, label: _label);
                    }),

                    Spacer(flex: 2),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),

      floatingActionButton: SpeedDial(
        buttonSize: 72,
        childrenButtonSize: 72,
        icon: Icons.add,
        activeIcon: Icons.close,
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
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 30,
                letterSpacing: .5,
            ),
            labelBackgroundColor: Colors.orange[400]
          ),

          SpeedDialChild(
              child: Icon(Icons.photo),
              backgroundColor: Colors.white,
              onTap: getImageFromGallery,
              label: 'Gallery',
              labelStyle: TextStyle(
                fontWeight: FontWeight.w400,
                color: Colors.white,
                fontSize: 30,
                letterSpacing: .5,
            ),
            labelBackgroundColor: Colors.orange[400]
          ),
        ],
      ),
    );
  }

  Future<void> _alertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(':(',
            style: TextStyle(
              fontSize: 30,
            )
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('No classes found for the image.\nTry again?', 
                  style: TextStyle(
                    fontSize: 30,
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK',
                style: TextStyle(
                  fontSize: 30,
                )
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}