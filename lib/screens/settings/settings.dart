import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  double ttsVolume = 0.0;
  double ttsRate = 0.0;
  double backgroundVolume = 0.0;

  Future <void> getTtsVolume() async {
    DocumentSnapshot volumeSnapshot = await FirebaseFirestore.instance.collection('Tts').doc('volume').get();
    setState(() {
      ttsVolume = volumeSnapshot['volume'];
    });
  }

  Future updateTtsVolume(double volume) async {
    await FirebaseFirestore.instance.collection('Tts').doc('volume').set({ 'volume': volume });
  }

  Future <void> getTtsRate() async {
    DocumentSnapshot rateSnapshot = await FirebaseFirestore.instance.collection('Tts').doc('rate').get();
    setState(() {
      ttsRate = rateSnapshot['rate'];
    });
  }

  Future updateTtsRate(double rate) async {
    await FirebaseFirestore.instance.collection('Tts').doc('rate').set({ 'rate': rate });
  }

  Future <void> getBackgroundVolume() async {
    DocumentSnapshot backgroundSnapshot = await FirebaseFirestore.instance.collection('Background').doc('volume').get();
    setState(() {
      backgroundVolume = backgroundSnapshot['volume'];   
    });
  }

  Future updateBackgroundVolume(double bgVolume) async {
    await FirebaseFirestore.instance.collection('Background').doc('volume').set({ 'volume': bgVolume });
  }

  @override
  void initState() {
    super.initState();
    getTtsVolume();
    getTtsRate();
    getBackgroundVolume();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Settings',
        // titleTextStyle: TextStyle(
        //   fontSize: 30,
        // ),
        style: TextStyle(
          fontSize: 30,
          //fontWeight: FontWeight.w400,
          letterSpacing: .5,
        )),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
            child: Text("Pronunciation",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
            child: Text("Volume",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _volume(),
          // Divider(
          //   thickness: 5,
          //   indent: 20,
          //   endIndent: 20,
          // ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
            child: Text("Speech Rate",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _rate(),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
            child: Text("Background Music",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
            child: Text("Volume",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _backgroundVolume(),
        ],
      ),

    );
  }

  // Widget buildCheckBox() => ListTile(
  //   onTap: (){
  //     setState(() {
  //       this.value = !value;
  //     });
  //   },
  //     trailing: Checkbox(
  //     value: value,
  //     activeColor: Colors.orange[400],
  //     onChanged: (value){
  //       setState(() {
  //         this.value = value;
  //       });
  //     },
  //   ),
  //   title: Text('Save image to gallery', 
  //   style: TextStyle(
  //     fontSize: 20)
  //     ),
  // );

  Widget _volume() {
    return Slider(
      value: ttsVolume,
      onChanged: (newVolume) {
        setState((){
          ttsVolume = newVolume;
          updateTtsVolume(newVolume);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Volume: $ttsVolume",
      activeColor: Colors.orange[300],
    );
  }

  Widget _rate() {
    return Slider(
      value: ttsRate,
      onChanged: (newRate) {
        setState(() {
          ttsRate = newRate;
          updateTtsRate(newRate);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $ttsRate",
      activeColor: Colors.orange[300],
    );
  }

  Widget _backgroundVolume(){
    return Slider(
      value: backgroundVolume,
      onChanged: (newVolume) {
        setState(() {
          backgroundVolume = newVolume;
          updateBackgroundVolume(newVolume);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $backgroundVolume",
      activeColor: Colors.orange[300],
    );
  }


}