import 'package:flutter/material.dart';
import 'package:plum_test/layout/home_view.dart';
import 'package:provider/provider.dart';
import 'package:plum_test/models/image_model.dart';

class Home extends StatefulWidget {
  const Home({ Key key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool proceed = false;

  @override
  void initState() {
    super.initState();
    fetchBackgroundData();
  }

  Future fetchBackgroundData() async { //Future class for backgroundVolume upon Sign In
    await context.read<ImageData>().fetchBackgroundVolume;
    setState(() {
      proceed = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageData>(
      builder: (context, value, child){
        return (!proceed && !value.bgError) 
        ? SizedBox(height: MediaQuery.of(context).size.height, child: Center(child: CircularProgressIndicator()))
        : value.bgError
        ? Center(
            child: Text('Oops. \n${value.bgErrorMessage}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w400,
            ), ),
          )
        : HomeView(volume: value.bgVolume);
      }
    );
  }
}