import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Settings extends StatefulWidget {
  const Settings({ Key key, this.resetVolume }) : super(key: key);

  final Function resetVolume;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  double ttsVolume = 0.0;
  double ttsRate = 0.0;
  double backgroundVolume = 0.0;
  double sfxVolume = 0.0;

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

  Future <void> getSfxVolume() async {
    DocumentSnapshot sfxSnapshot = await FirebaseFirestore.instance.collection('Sfx').doc('volume').get();
    setState(() {
      sfxVolume = sfxSnapshot['volume'];
    });
  }

  Future updateSfxVolume(double volume) async {
    await FirebaseFirestore.instance.collection('Sfx').doc('volume').set({ 'volume': volume });
  }

  @override
  void initState() {
    super.initState();
    getTtsVolume();
    getTtsRate();
    getBackgroundVolume();
    getSfxVolume();
  }

  void onBackPressed(){
    widget.resetVolume(backgroundVolume);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange[400],
        centerTitle: true,
        title: Text('Settings',
        style: TextStyle(
          fontSize: 30,
          letterSpacing: .5,
        )),
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _settingsHeading("Pronunciation"),
          _divider(),
          _settingsSubheading("Volume"),
          _volume(),
          _settingsSubheading("Speech Rate"),
          _rate(),

          _settingsHeading("Background Music"),
          _divider(),
          _settingsSubheading("Volume"),
          _backgroundVolume(),

          _settingsHeading("Sound Effects"),
          _divider(),
          _settingsSubheading("Volume"),
          _sfxVolume(),
        ],
      ),
    );
  }

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
          widget.resetVolume(newVolume);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $backgroundVolume",
      activeColor: Colors.orange[300],
    );
  }

  Widget _sfxVolume(){
    return Slider(
      value: sfxVolume,
      onChanged: (newVolume){
        setState(() {
          sfxVolume = newVolume;
          updateSfxVolume(newVolume);
        });
      },
      min: 0.0,
      max: 1.0,
      divisions: 10,
      label: "Rate: $sfxVolume",
      activeColor: Colors.orange[300],
    );
  }

  Widget _settingsHeading(String text){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
        child: Text("$text",
        style: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _settingsSubheading(String text){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 0, 0),
      child: Text("$text",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  Widget _divider(){
    return Divider(
      thickness: 5,
      indent: 20,
      endIndent: 20,
    );
  }
}