import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plum_test/layout/register_view.dart';
import 'package:plum_test/user.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key key, this.setRegister}) : super(key: key);

  final Function setRegister;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> with SingleTickerProviderStateMixin {

  String username;
  String password;
  String errorMessage;
  AudioCache player = AudioCache(prefix: 'assets/audio/');

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(), //Unfocus current focus on background tap
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: hexColors('#f9a603'),
          ),
          child: AnimatedBackground(
            behaviour: RacingLinesBehaviour(),
            vsync: this,
            child: ListView(
              children: [
                Column(
                  children: [
                    usernameInput(),
                    passwordInput(),
                    loginButton(),
                    registerPageButton(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget usernameInput(){ //Textfield for username input
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 50, right: 50),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.2,
        width: MediaQuery.of(context).size.width,
        child: TextField(
          style: TextStyle(
            fontSize: 30,
            color: Colors.white,
          ),
          onChanged: setUsername,
          onTap: playClick,
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: hexColors('#f9a603'),
            labelText: 'Username',
            labelStyle: TextStyle(
              fontSize: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordInput(){ //Textfield for password input
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
            border: InputBorder.none,
            fillColor: hexColors('#f9a603'),
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(){ //Button to authenticate password and username
    return Padding(
      padding: EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        child: TextButton(
          onPressed: () async {
            player.play('click_pop.mp3');
            String status = await widget.setRegister(username, password);
            
            if (status == ""){
              User.username = username;
              User.password = password;
              Navigator.of(context).pushReplacementNamed('/home');
            } else {
              Fluttertoast.showToast(
                msg: "$status", 
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
                  color: hexColors('#f9a603'),
                  fontSize: 30,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: hexColors('#f9a603'),
                size: 45,
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget registerPageButton(){ //Button to redirect to Register View
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 50),
      child: Container(
        alignment: Alignment.topRight,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Row(
          children: [
            Text(
              'Register?',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white,
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.width * 0.4),
            TextButton(
              onPressed: () {
                player.play('click_pop.mp3');
                Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterView())
                );
              },
              child: Text(
                'Sign Up',
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

  void setUsername(String name){ //Set username input to username variable
    setState(() {
      username = name;
    });
    //print(username);
  }

  void setPassword(String pass){ //Set password input to password variable
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