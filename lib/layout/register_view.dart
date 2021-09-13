import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({ Key key }) : super(key: key);

  @override
  _RegisterViewState createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {

  String username;
  String password;
  String message;

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
    );
  }

  Widget registerUsername(){
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
          decoration: InputDecoration(
            border: InputBorder.none,
            fillColor: Colors.orangeAccent,
            labelText: 'New Username',
            labelStyle: TextStyle(
              fontSize: 50,
              color: Colors.white70,
            ),
          ),
        ),
      ),
    );
  }

  Widget registerPassword(){
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
            labelText: 'New Password',
            labelStyle: TextStyle(
              color: Colors.white70,
              fontSize: 50,
            ),
          ),
        ),
      ),
    );
  }

  Widget registerButton(){
    return Padding(
      padding: EdgeInsets.only(top: 40, right: 50, left: 200),
      child: Container(
        alignment: Alignment.bottomRight,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(15)
        ),
        child: TextButton(
          onPressed: () async {
            await checkRegisterData(username);

            if (message == ""){
              await updateRegisterData(username, password);
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

  Widget loginPageButton(){
    return Padding(
      padding: EdgeInsets.only(top: 30, left: 50),
      child: Container(
        alignment: Alignment.topRight,
        height: MediaQuery.of(context).size.height * 0.2,
        child: Row(
          children: [
            Text(
              'Already have an account?',
              style: TextStyle(
                fontSize: 30,
                color: Colors.white70,
              ),
            ),
            SizedBox(width: 20),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
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

  Future checkRegisterData(String username) async {
    CollectionReference registerCollection = FirebaseFirestore.instance.collection('User');
    QuerySnapshot querySnapshots = await registerCollection.get();

    for (QueryDocumentSnapshot registerSnapshot in querySnapshots.docs){
      if(registerSnapshot.id == username){
        message = "Username taken. Please try again.";
        break;
      } else {
        message = "";
      }
    }
  }

  Future updateRegisterData(String username, String password) async {
    await FirebaseFirestore.instance.collection('User').doc(username).set({'password' : password});
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