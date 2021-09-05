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

  @override
  void initState() {
    super.initState();
    context.read<ImageData>().fetchBackgroundVolume;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageData>(
      builder: (context, value, child){
        return HomeView(volume: value.bgVolume);
      });
  }
}