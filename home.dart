import 'package:flutter/material.dart';

class Home extends StatefulWidget{
  @override
  HomeState createState() => HomeState();
}
class HomeState extends State<Home>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Text("This is Home page")
      ],),
    );
  }
}