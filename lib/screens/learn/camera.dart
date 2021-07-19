import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:path_provider/path_provider.dart';

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
    final image = await imagePicker.getImage(source: ImageSource.camera);
    setState(() {
      //Assign image to image file if image is taken
      if (image == null){
        _image = null;
      } else {
        _image = File(image.path);
        GallerySaver.saveImage(image.path); // Save image to gallery
      }
    });
  }

  Future getImageFromGallery() async{
    //Access gallery and get image from gallery
    final image = await imagePicker.getImage(source: ImageSource.gallery);
    setState(() {
      //Assign image to image file if image is selected
      if (image == null){
        _image = null;
      } else {
        _image = File(image.path);
      }
    });
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
      body: Center(
        child: _image == null ? Text('Tap on the Camera to take a picture') : Image.file(_image, height: 440),
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