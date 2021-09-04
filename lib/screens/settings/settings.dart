import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class Settings extends StatefulWidget {
  const Settings({ Key key, this.resetVolume }) : super(key: key);

  final Function resetVolume;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings>{

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: hexColors('#3f681c'),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Spacer(),
            Icon(SimpleLineIcons.settings, color: Colors.white, size: 40),
            SizedBox(width: MediaQuery.of(context).size.width * (1/36)),
            Text('Settings',
            style: TextStyle(
              fontSize: 28,
              color: Colors.white,
              letterSpacing: .5,
            )),
            Spacer(flex: 2),
          ],
        ),
      ),

      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _settingsHeading("Pronunciation", Ionicons.md_volume_high),
            _divider(),
            _settingsSubheading("Volume"),
            _volume(),
            _settingsSubheading("Speech Rate"),
            _rate(),

            _settingsHeading("Background Music", Foundation.sound),
            _divider(),
            _settingsSubheading("Volume"),
            _backgroundVolume(),

            _settingsHeading("Sound Effects", Entypo.sound_mix),
            _divider(),
            _settingsSubheading("Volume"),
            _sfxVolume(),
          ],
        ),
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
      inactiveColor: hexColors('#f8f5f2'),
      activeColor: hexColors('#f9a603'),
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
      inactiveColor: hexColors('#f8f5f2'),
      activeColor: hexColors('#f9a603'),
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
      inactiveColor: hexColors('#f8f5f2'),
      activeColor: hexColors('#f9a603'),
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
      inactiveColor: hexColors('#f8f5f2'),
      activeColor: hexColors('#f9a603'),
    );
  }

  Widget _settingsHeading(String text, IconData iconName){
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 0, 8),
        child: Row(
          children: [
            Icon(iconName, color: Colors.white, size: 34),
            SizedBox(width: MediaQuery.of(context).size.width * (1/18)),
            Text("$text",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
      ),
          ],
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
        color: Colors.white,
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

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }
}