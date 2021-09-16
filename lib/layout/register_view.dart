import 'package:animated_background/animated_background.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:audioplayers/audioplayers.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({ Key key }) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> with SingleTickerProviderStateMixin {

  String username;
  String password;
  String message;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(), //Unfocus current focus on background tap
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
              color: hexColors('#ffbb00'),
            ),
          child: AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                baseColor: Colors.white,
              )
            ),
            vsync: this,
            child: ListView(
              children: [
                Column(
                  children: [
                    registerUsername(),
                    registerPassword(),
                    registerButton(),
                    loginPageButton(),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget registerUsername(){ //Textfield for username input
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          onChanged: setUsername,
          onTap: playClick,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: hexColors('#ffbb00'),
            labelText: 'New Username',
            labelStyle: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget registerPassword(){ //Textfield for password input
    return Padding(
      padding: EdgeInsets.only(top: 20, right: 50, left: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
          ),
          obscureText: true,
          onChanged: setPassword,
          onTap: playClick,
          decoration: InputDecoration(
            fillColor: hexColors('#ffbb00'),
            border: InputBorder.none,
            labelText: 'New Password',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButton(){ //Button to register new username and password
    return Padding(
      padding: EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(15)
        ),
        child: TextButton(
          onPressed: () async {
            player.play('click_pop.mp3');
            await checkRegisterData(username, password);

            if (message == ""){
              await updateRegisterData(username, password);
              await setInitialData(username, password);
              Navigator.pop(context);
            } else {
              Fluttertoast.showToast(
                msg: "$message", 
                toastLength: Toast.LENGTH_LONG, 
                gravity: ToastGravity.BOTTOM,
                fontSize: 22.0,
                backgroundColor: Colors.black54,
                textColor: Colors.white
              );
            }
          }, 
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'OK',
                style: TextStyle(
                  color: hexColors('#ffbb00'),
                  fontSize: 30,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: hexColors('#ffbb00'),
                size: 45,
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget loginPageButton(){ //Button to redirect page to Login View
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 50),
      child: Container(
        alignment: Alignment.topLeft,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Row(
          children: [
            Text(
              'Registered?',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () {
                player.play('click_pop.mp3');
                Navigator.pop(context);
              },
              child: Text(
                'Sign In',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future checkRegisterData(String username, String password) async { //Check if username is already registered
    CollectionReference registerCollection = FirebaseFirestore.instance.collection('User');
    QuerySnapshot querySnapshots = await registerCollection.get();

    if (username == null || password == null){
      message = "Username or password\nmust not be blank.\nPlease try again.";
    } else {
      if (querySnapshots.docs.length == 0){
        message = "";
      } else {
        for (QueryDocumentSnapshot registerSnapshot in querySnapshots.docs){
          if(registerSnapshot.id == username){
            message = "Username taken. Please try again.";
            break;
          } else {
            message = "";
          }
        }
      }
    }
  }

  //Add username and password to Cloud Firestore
  Future updateRegisterData(String username, String password) async {
    await FirebaseFirestore.instance.collection('User').doc(username).set({'password' : password});
  }

  //Set initial data upon registration
  Future setInitialData(String username, String password) async {
    await FirebaseFirestore.instance.collection('Background').doc(username).set({'volume' : 0.5});
    await FirebaseFirestore.instance.collection('Sfx').doc(username).set({'volume' : 0.5});
    await FirebaseFirestore.instance.collection('Tts').doc(username).set({'volume' : 0.5, 'rate' : 1.0});
  }

  //Set username input to username variable
  void setUsername(String name){
    setState(() {
      username = name;
    });
    //print(username);
  }

  //Set password input to password variable
  void setPassword(String pass){
    setState(() {
      password = pass;
    });
    //print(password);
  }

  Color hexColors(String hexColor){
    return Color(int.parse(hexColor.replaceAll('#', '0xff')));
  }

  Future playClick() async{
    await player.play('click_pop.mp3');
  }
}