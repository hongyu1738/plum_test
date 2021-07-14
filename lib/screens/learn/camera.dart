import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Camera extends StatefulWidget {

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {

  //Create an image object
  File _image;

  //Instantiate image object
  final imagePicker = ImagePicker();

  //Function to get image from Camera
  Future getImageFromCamera() async{
    //Access camera and get image from camera
    final image = await imagePicker.getImage(source: ImageSource.camera, maxHeight: 480, maxWidth: 600);
    setState(() {
      //Assign image to image file
      _image = File(image.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _image == null ? Text('Tap on the Camera to take a picture') : Image.file(_image),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImageFromCamera,
        backgroundColor: Colors.black,
        child: Icon(
          Icons.camera_alt,
          color: Colors.white,
        ),
      ),
    );
  }
}