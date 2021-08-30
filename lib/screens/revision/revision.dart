import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:plum_test/layout/revision_vertical.dart';
import 'package:animate_do/animate_do.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Revision extends StatefulWidget {
  const Revision({ Key key }) : super(key: key);

  @override
  _RevisionState createState() => _RevisionState();
}

class _RevisionState extends State<Revision> {

  void initState() {
    super.initState();
    context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
    context.read<ImageData>().fetchClassData; //Fetch class data of type ClassData
    context.read<ImageData>().fetchVolumeData;
    context.read<ImageData>().fetchRateData;

  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Revision',
        style: TextStyle(
          fontSize: 30,
          letterSpacing: .5,
        )),
      ),

      body: BounceInDown(
        child: LiquidPullToRefresh(
          springAnimationDurationInMilliseconds: 500,
          showChildOpacityTransition: false,
          animSpeedFactor: 1.5,
          color: Colors.orangeAccent,
          onRefresh: () async {
            await context.read<ImageData>().fetchImageData; //Fetch image data of type ImageData
            await context.read<ImageData>().fetchClassData; //Fetch class data of type ClassData
            await context.read<ImageData>().fetchVolumeData;
            await context.read<ImageData>().fetchRateData;
          },
          child: Center(
            child: Consumer<ImageData>(
              builder: (context, value, child){
                return (value.classMap.length == 0 && !value.classError) //Check for availability of elements and errors for classMap
                && (value.imageMap.length == 0 && !value.imageError) //Check for availability of elements and errors for ImageMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : value.classError ? Text('Oops. ${value.classErrorMessage}',
                //Error message when classError == true
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  //fontWeight: FontWeight.w400,
                ), )
                : value.imageError ? Text('Oops. ${value.imageErrorMessage}',
                //Error message when imageError == true
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  //fontWeight: FontWeight.w400,
                ), )
                : value.classMap.length == 0 && value.imageMap.length != 0
                //Load circular progress indicator when fetching data for classMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : value.imageMap.length == 0 && value.classMap.length != 0
                //Load circular progress indicator when fetching data for imageMap
                ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
                : ListView.builder(
                  //   physics: BouncingScrollPhysics(
                  //   parent: AlwaysScrollableScrollPhysics()
                  // ),
                  itemCount: value.classResults.length, //Determine number of rows/total number of classes
                  itemBuilder: (context, index){
                    return VerticalView(classResult: value.classResults[index], imageResult: value.imageResults, 
                    volume: value.ttsVolume, rate: value.ttsRate);
                  }
                );
              },
            )
          )  
        ),
      )
    );
  }
}
