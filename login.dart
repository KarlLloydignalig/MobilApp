import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'registration.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:paraiso/Utils/database_helper.dart';
import 'package:paraiso/Pages/HomePage/home.dart';

class Login extends StatefulWidget{
  @override
  LoginState createState() => LoginState();

}

class LoginState extends State<Login>{

  DataBaseHelper dataBaseHelper =  DataBaseHelper();
  Icon visibilityIcon = Icon(Icons.visibility,color: Colors.white,);
  bool isVisible = false;
  bool isValid = false;
  String invalidCredentials = "";
  Color inputTextColor = Colors.white;
  FocusNode myFocusNode = new FocusNode();
  final TextEditingController password = new TextEditingController();
  final TextEditingController userName = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    const Color textFieldColor =  Color.fromARGB(200, 0, 0, 0);
    final fieldWidth = 350.0;
    final TextField usernameField = TextField(
      focusNode: myFocusNode,
      controller:userName,decoration: const InputDecoration(
      prefixIcon: const Icon(Icons.person, color: Colors.white,),
      filled: true,fillColor: textFieldColor,
      labelStyle: TextStyle(color:Colors.white),
      labelText: "Username",
      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 0),borderRadius: BorderRadius.all(Radius.circular(100)),),
    ),
      style: TextStyle(fontSize: 16,color: inputTextColor),onChanged: (String value){
      setState(() {
        if(!isValid) inputTextColor = Colors.white;
        invalidCredentials = "";
      });
    },);

    final TextField passwordField = TextField(controller: password,decoration: InputDecoration(
      filled: true,fillColor: textFieldColor,
      labelStyle: TextStyle(color:Colors.white),
      labelText: "password",
      prefixIcon: const Icon(Icons.lock, color: Colors.white,),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.green, width: 1),
        borderRadius: BorderRadius.all(Radius.circular(100))
        ,),),
      obscureText: !isVisible,style: TextStyle(fontSize: 16,color: inputTextColor),onChanged: (String value){
        setState(() {
          if(!isValid) inputTextColor = Colors.white;
          invalidCredentials = "";
        });
      },);

    return Scaffold(
        body: Stack(
            children:[

              Container(
                alignment: Alignment.center,
                child:CarouselSlider(
                  options: CarouselOptions(
                      height: double.infinity,
                      autoPlayInterval: Duration(seconds: 10),
                      viewportFraction: 1,
                      autoPlay: true,
                      enlargeCenterPage: false
                  ),
                  items: [
                    for(var i in [1,2,3,4,5] )
                      Image.asset("assets/backgrounds/bg"+i.toString()+".png",fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        alignment: Alignment.center
                        ,),
                  ],),),
              Align(alignment: Alignment.bottomCenter,
                child:
                Icon(Icons.update,size: 50,color: Colors.black,),),
              Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [
                          0.1,
                          1
                        ],
                        colors: [
                          Color.fromARGB(100, 0, 100, 50),
                          Color.fromARGB(50, 255, 255, 255)
                        ]
                    ),
                  ),

                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                    Image.asset('assets/logo.png'),//logo
                    Container(
                      decoration: BoxDecoration(
                        //color: Colors.white30,
                          borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight:  Radius.circular(50),bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                          gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [
                                0.1,
                                0.2
                              ],
                              colors: [
                                Color.fromARGB(100, 50, 50, 50),
                                Color.fromARGB(100, 0, 100, 50)
                              ]
                          )
                      ),
                      margin: EdgeInsets.only(right: 10,left: 10),
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
                      //color: Color.fromARGB(100, 100, 100, 100),
                      child:Center(
                        child: Column(mainAxisAlignment: MainAxisAlignment.end,mainAxisSize:MainAxisSize.max,children: [
                          Container(

                            margin: EdgeInsets.only(bottom: 20),
                            child: Text("Login",style: TextStyle(fontSize: 36,fontWeight: FontWeight.bold,color: Colors.white,shadows: [Shadow(color: Colors.grey,offset: Offset.fromDirection(5),blurRadius: 10)]),),
                          ),
                          Center(
                            child: Container(
                                height: 50.0,
                                width: fieldWidth,
                                child: Align(
                                  alignment: FractionalOffset(0.2, 0.6),
                                  child:usernameField,
                                )
                            ),
                          ),
                          Center(
                            child: Container(
                              height: 50,
                              width: fieldWidth,
                              margin: const EdgeInsets.only(top: 10),
                              child: Align(
                                  alignment: FractionalOffset(0.2, 0.6),
                                  child: Stack(alignment: Alignment.centerRight,children: [passwordField,
                                    IconButton(icon: visibilityIcon,onPressed: (){
                                      setState(() {
                                        if(!isVisible)
                                        {
                                          print(password.text);
                                          visibilityIcon = Icon(Icons.visibility,color: Colors.white,);
                                          isVisible = true;
                                        }
                                        else
                                        {
                                          visibilityIcon = Icon(Icons.visibility_off,color: Colors.white,);
                                          isVisible = false;
                                        }
                                      });
                                    },)],)),),
                          ),
                          Center(child: Text("$invalidCredentials",style: TextStyle(color: Colors.red[800])),),
                          Center(child: RaisedButton(

                            onPressed: (){
                              setState(() {
                                var value = onPressedLogin(userName.text,password.text);
                                value.then((isValid) =>{
                                if(isValid){
                                    inputTextColor = Colors.grey[850],
                                    invalidCredentials = "",
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()))
                                }
                                else{
                                  inputTextColor = Colors.red[800],
                                  invalidCredentials = "Invalid Credentials"
                                }
                              } );

                              });
                            }
                            ,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
                            color: Color.fromARGB(200, 0, 100, 50),
                            focusColor: Colors.grey[400],
                            child: Container(
                              width: fieldWidth-30,
                              child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Continue",style: TextStyle(color: Colors.white,fontSize: 20),),
                                    Icon(Icons.login_outlined,color:Colors.white ,)
                                  ]),),),),

                          Container(
                              child:Center(
                                child:TextButton(
                                  onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Register()));},
                                  child: Text("Create new account.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),),),))
                        ],),) ,),
                  ],)),

            ]));



  }

  Future<bool> onPressedLogin(String userName,String password) async{
    String testPassword = "1";
    String testUsername = "1";
    var value = await dataBaseHelper.getUserList();
    for(User userOB in value){
      //print(userOB.password+" "+password),
      if(userName == userOB.username && password == userOB.password){
        return true;
      }
    }
    return false;
  }
}