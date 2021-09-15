import 'package:flutter/material.dart';
import 'package:plum_test/layout/login_view.dart';
import 'package:plum_test/models/image_model.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({ Key key }) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageData>(
      builder: (context, value, child){
        return LoginView(setRegister: value.setRegisterData);
      },
    );
  }
}