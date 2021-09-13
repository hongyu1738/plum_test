import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:plum_test/layout/register_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({ Key key, this.setRegister}) : super(key: key);

  final Function setRegister;
  // final String uid;
  // final bool uidError;
  // final String uidErrorMessage;

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String username;
  String password;
  String errorMessage;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus.unfocus(),
      child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            color: Colors.orangeAccent,
          ),
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
    );
  }

  Widget usernameInput(){
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
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.orangeAccent,
            labelText: 'Username',
            labelStyle: TextStyle(
              fontSize: 50,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget passwordInput(){
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
          decoration: InputDecoration(
            border: InputBorder.none,
            labelText: 'Password',
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton(){
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
            String status = await widget.setRegister(username, password);
            
            if (status == ""){
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
                  color: Colors.orangeAccent,
                  fontSize: 30,
                ),
              ),
              Icon(
                Icons.arrow_forward,
                color: Colors.orangeAccent,
                size: 45,
              ),
            ],
          )
        ),
      ),
    );
  }

  Widget registerPageButton(){
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
                color: Colors.white70,
              ),
            ),
            SizedBox(width: 20),
            TextButton(
              onPressed: () {
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

  void setUsername(String name){
    setState(() {
      username = name;
    });
    print(username);
  }

  void setPassword(String pass){
    setState(() {
      password = pass;
    });
    print(password);
  }
}