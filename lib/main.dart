import 'package:flutter/material.dart';
import 'Pages/Login_Registration/login.dart';
import 'package:paraiso/Utils/my_colors.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: BlueSubmerge.withAlpha(255)),
      home: Login()

    );
  }

}