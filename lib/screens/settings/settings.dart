import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Settings extends StatefulWidget {
  const Settings({ Key key }) : super(key: key);

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  double volume = 0.0;
  double rate = 0.0;

  Future <void> getVolume() async {
    DocumentSnapshot volumeSnapshot = await FirebaseFirestore.instance.collection('Tts').doc('volume').get();
    setState(() {
      volume = volumeSnapshot['volume'];
    });
  }

  Future updateVolume(double volume) async {
    await FirebaseFirestore.instance.collection('Tts').doc('volume').set({ 'volume': volume });
  }

  Future <void> getRate() async {
    DocumentSnapshot rateSnapshot = await FirebaseFirestore.instance.collection('Tts').doc('rate').get();
    setState(() {
      rate = rateSnapshot['rate'];
    });
  }

  Future updateRate(double rate) async {
    await FirebaseFirestore.instance.collection('Tts').doc('rate').set({ 'rate': rate });
  }

  @override
  void initState() {
    super.initState();
    getVolume();
    getRate();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Settings'),
        titleTextStyle: TextStyle(
          fontSize: 24.0,
        ),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
            child: Text("Pronunciation",
            style: GoogleFonts.ibmPlexSans(
              fontSize: 28,
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
            style: GoogleFonts.ibmPlexSans(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _volume(),
          Divider(
            thickness: 5,
            indent: 20,
            endIndent: 20,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
            child: Text("Speech Rate",
            style: GoogleFonts.ibmPlexSans(
              fontSize: 24,
              fontWeight: FontWeight.w400,
              ),
            ),
          ),
          _rate(),
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
      value: volume,
      onChanged: (newVolume) {
        setState((){
          volume = newVolume;
          updateVolume(newVolume);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Volume: $volume",
      activeColor: Colors.orange[300],
    );
  }

  Widget _rate() {
    return Slider(
      value: rate,
      onChanged: (newRate) {
        setState(() {
          rate = newRate;
          updateRate(newRate);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $rate",
      activeColor: Colors.orange[300],
    );
  }


}