import 'package:flutter/material.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:paraiso/Utils/database_helper.dart';

class Register extends StatefulWidget{
  @override
  RegisterState createState() => RegisterState();
}

class RegisterState extends State<Register>{
  final width = 100.0;
  final globalKey = GlobalKey<ScaffoldState>();

  DataBaseHelper dataBaseHelper = DataBaseHelper();
  List<User> userList;
  int count = 0;

  Icon visibilityIcon = Icon(Icons.visibility_off);
  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final TextEditingController emailAddress = new TextEditingController();
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    if(userList == null){
      userList = List<User>();
    }
    return Scaffold(
        body:SingleChildScrollView(
            child:Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                //color: Color.fromARGB(255, 0, 0, 0),
                  image: DecorationImage(
                    image: AssetImage("assets/backgrounds/bg1.png"),
                    fit: BoxFit.cover,
                  )
              ),
              child:Column(children:[
                Container(
                  margin: EdgeInsets.fromLTRB(0, 100, 0,0),
                  child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,children: [
                    Image.asset('assets/logo.png'),
                    Text("Registration",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),)
                  ],),
                ),
                Container(

                  child: Container(
                    margin: EdgeInsets.fromLTRB(0, 100, 0, 100),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      //border: Border.all(color: Colors.black45),
                      color: Color.fromARGB(220, 255, 255, 255),
                      // boxShadow: [new BoxShadow(
                      //   color: Colors.grey,
                      //   blurRadius: 10.0,
                      // )],
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.center,children: [
                      Text("Personal Information",style: TextStyle(fontSize: 13),),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black45)
                        ),
                        child: Column(children: [
                          //lastfirst name
                          Center(child: Container(
                            height: 50,
                            child: TextField(controller: firstName,decoration: InputDecoration(hintText: "First Name"),),
                          ),),
                          Center(child: Container(
                            height: 50,
                            child: TextField(controller: lastName,decoration: InputDecoration(hintText: "Last Name"),),
                          ),),
                        ],),),

                      Container(
                        margin:  const EdgeInsets.fromLTRB(0, 20, 0, 0),
                        child: Text("Account Information",style: TextStyle(fontSize: 13),),),
                      //user,password
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black45)
                        ),
                        child: Column(
                          children: [
                            Center(child: Container(
                              height: 50,
                              child: TextField(controller:username,decoration: InputDecoration(hintText: "Username"),),
                            ),),
                            Center(
                              child: Container(
                                height: 50,
                                child: Align(
                                    alignment: FractionalOffset(0.2, 0.6),
                                    child: Stack(alignment: Alignment.centerRight,children: [ TextField(controller:password,decoration: InputDecoration(hintText: "Password"),obscureText: !isVisible,),
                                      IconButton(icon: visibilityIcon,onPressed: (){
                                        setState(() {
                                          if(!isVisible)
                                          {
                                            print(password.text);
                                            visibilityIcon = Icon(Icons.visibility);
                                            isVisible = true;
                                          }
                                          else
                                          {
                                            visibilityIcon = Icon(Icons.visibility_off);
                                            isVisible = false;
                                          }
                                        });
                                      },)],
                                    )
                                ),
                              ),
                            ),
                            Center(child: Container(
                              height: 50,
                              child: TextField(controller:emailAddress,decoration: InputDecoration(hintText: "Email Address"),),
                            ),),
                          ],
                        ),
                      ),


                      Builder(builder: (BuildContext ncontext){
                        return Center(child:
                        //Register BTN
                        RaisedButton(color: Colors.green[400],focusColor: Colors.grey[400],
                          onPressed: (){

                            if(firstName.text.isNotEmpty &&lastName.text.isNotEmpty &&
                                emailAddress.text.isNotEmpty &&username.text.isNotEmpty &&
                                password.text.isNotEmpty){
                              //dataBaseHelper.deleteAll();
                              User user = new User(firstName.text,lastName.text,emailAddress.text,username.text,password.text);
                              //dataBaseHelper.insertUser(user);
                              dataBaseHelper.getUserList().then((value) => {
                                if(value.isNotEmpty){
                                  for(User userOB in value){
                                    if(userOB.username == user.username){
                                      _snackBar(context: ncontext,message: "Username is already used.",actionLabel: "okay",duration: 3,textColor: Colors.redAccent[100])
                                    }
                                    else{
                                        ClearFields(),
                                      _snackBar(context: ncontext,message: "You are now ready to travel!",actionLabel: "okay",duration: 3,textColor: Colors.green[600]),
                                      dataBaseHelper.insertUser(user)
                                    }
                                  }
                                }
                                else{
                                  dataBaseHelper.insertUser(user)
                                }

                              }
                              );

                            }
                            else {
                              print(firstName.text+"\n"+lastName.text+"\n"+emailAddress.text+"\n"+username.text+"\n"+password.text+"\n");
                              _snackBar(context: ncontext,message: "Please fill it all up.",actionLabel: "okay",duration: 3,textColor: Colors.redAccent[100]);
                            }
                          },

                          child: Row(mainAxisAlignment: MainAxisAlignment.center,children:
                          [Text("Register",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                            Icon(Icons.app_registration,size: 20,color: Colors.white,)],),),);
                      }),
                      //ResetBTN
                      Builder(builder:(BuildContext ncontext){
                        return Center(child:
                        RaisedButton(
                          color: Colors.black45,
                          onPressed: (){
                            _snackBar(context: ncontext,message: "Are you sure to reset?",actionLabel: "Confirm",duration: 5,action: (){
                              setState(() {
                                ClearFields();
                              });
                            });
                          },
                          child: Row(mainAxisAlignment: MainAxisAlignment.center,children:
                          [Text("Reset",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                            Icon(Icons.redo_sharp,size: 20,color: Colors.white,)],),)
                          ,);
                      }),

                    ],),),
                )]),))
    );
  }

  void _snackBar({BuildContext context,String message,Function action,String actionLabel,duration,Color textColor}){
    if(action == null){
      action = (){
        //print('empty');
      };
    }
    Scaffold.of(context).showSnackBar(
        SnackBar(
          action: SnackBarAction(
            label: actionLabel,
            onPressed: action,
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.grey[850],
          duration: Duration(seconds: duration),
          content: Text(message,style: TextStyle(fontSize: 15,color: textColor),),
        ));
  }

  void ClearFields(){
    password.clear();
    username.clear();
    emailAddress.clear();
    lastName.clear();
    firstName.clear();
  }



}