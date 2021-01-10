import 'package:flutter/material.dart';
import 'package:paraiso/Utils/my_colors.dart';
import 'package:paraiso/Models/places_model.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:paraiso/Pages/Login_Registration/login.dart';
import 'package:paraiso/Utils/database_helper_place.dart';
import 'package:paraiso/Utils/database_helper_user.dart';
import 'package:recase/recase.dart';
import 'package:paraiso/Utils/my_colors.dart';


class Me extends StatefulWidget{
  final User _user;
  final List<Place> _places;
  Me(this._user,this._places);
  @override
  MeState createState() => MeState(_user,_places);
}

class MeState extends State<Me>{
  DataBaseHelperPlace dataBaseHelperPlace = DataBaseHelperPlace();
  DataBaseHelperUser dataBaseHelperUser = DataBaseHelperUser();
  final User _user;
  List<Place> _places;
  MeState(this._user,this._places);
  Icon visibilityIcon = Icon(Icons.visibility_off);
  final TextEditingController firstName = new TextEditingController();
  final TextEditingController lastName = new TextEditingController();
  final TextEditingController address = new TextEditingController();
  final TextEditingController username = new TextEditingController();
  final TextEditingController password = new TextEditingController();
  final TextEditingController emailAddress = new TextEditingController();
  bool isVisible = false;
  ScrollController mainScrollView = new ScrollController();
  bool update = false;
  List<bool> isChange = new List<bool>();
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    isChange.add(false);
    isChange.add(false);
    isChange.add(false);
    isChange.add(false);
    isChange.add(false);
    isChange.add(false);
    lastName.text = _user.lastName;
    firstName.text = _user.firstName;
    address.text = _user.address;
    username.text = _user.username;
    password.text = _user.password;
    emailAddress.text = _user.emailAddress;
  }
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(

      appBar: AppBar(
        actions: [
          TextButton(onPressed: ()async{
            _showMyDialog(context);
          },
              child: Text("Logout",style: TextStyle(fontSize: 20,color: ScubaBlue.withAlpha(255)),))
        ],
        toolbarHeight: 80,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_user.username,style: TextStyle(fontWeight: FontWeight.bold),),
            Text(_user.firstName.toString().titleCase+" "+_user.lastName.toString().titleCase,style: TextStyle(color: Colors.white,fontSize: 13),),
          ],
        ),
      ),

      body: FutureBuilder<List<User>>(
          future: dataBaseHelperUser.getUsersList(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot){
            if(snapshot.hasData) {
              snapshot.data.indexOf(_user);
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      updateInfo()
                    ],
                  ),
                ),
              );
            }
            else return Center(child: CircularProgressIndicator(),);
          }),
    );



  }
  Container updateInfo(){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        //color: Color.fromARGB(255, 0, 0, 0),
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/bg1.png"),
            fit: BoxFit.cover,
          )
      ),
      child:Column(
          children:[
            Container(
              margin: EdgeInsets.fromLTRB(0, 50, 0,0),
              child: Column(mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset('assets/logo.png',fit: BoxFit.cover,height: 50,),
                  Text("Your Informations",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  Container(
                    width: 200,
                    child: RaisedButton(
                        splashColor: ScubaBlue.withAlpha(255),
                        hoverColor: ScubaBlue.withAlpha(255),
                        elevation: 10,
                        color: BlueSubmerge.withAlpha(200),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                        ),
                        child: Text("Update",style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          setState(() {
                            if(update)update = false;
                            else update = true;
                          });
                        }),
                  )
                ],),
            ),
            Container(

              child: Container(
                margin: EdgeInsets.fromLTRB(0, 50, 0, 100),
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
                        borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                        border: Border.all(color: Colors.black45)
                    ),
                    child: Column(children: [
                      //lastfirst name
                      Center(child: Container(
                        height: 50,
                        child: TextField(controller: firstName,decoration: InputDecoration(hintText: "First Name"),readOnly: update,onChanged: (value){
                          setState(() {
                            if(value != _user.firstName)isChange[0] = true;
                            else isChange[0] = false;
                          });

                        },),
                      ),),
                      Center(child: Container(
                        height: 50,
                        child: TextField(controller: lastName,decoration: InputDecoration(hintText: "Last Name"),readOnly: update,onChanged: (value){
                          setState(() {
                            if(value != _user.lastName)isChange[1] = true;
                            else isChange[1] = false;
                          });

                        }),
                      ),),
                      Center(child: Container(
                        height: 50,
                        child: TextField(controller: address,decoration: InputDecoration(hintText: "Address"),readOnly: update,onChanged: (value){
                          setState(() {
                            if(value != _user.address)isChange[2] = true;
                            else isChange[2] = false;
                          });

                        }),
                      ),),
                    ],),),

                  Container(
                    margin:  const EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Text("Account Information",style: TextStyle(fontSize: 13),),),
                  //user,password
                  Container(
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 30),
                    decoration: BoxDecoration(
                      //borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(30)),
                        border: Border.all(color: Colors.black45)
                    ),
                    child: Column(
                      children: [
                        Center(child: Container(
                          height: 50,
                          child: TextField(controller:username,decoration: InputDecoration(hintText: "Username"),readOnly: update,onChanged: (value){
                            setState(() {
                              if(value != _user.username)isChange[3] = true;
                              else isChange[3] = false;
                            });

                          }),
                        ),),
                        Center(
                          child: Container(
                            height: 50,
                            child: Align(
                                alignment: FractionalOffset(0.2, 0.6),
                                child: Stack(alignment: Alignment.centerRight,children: [ TextField(controller:password,decoration: InputDecoration(hintText: "Password"),obscureText: !isVisible,readOnly: update,onChanged: (value){
                                  setState(() {
                                    if(value != _user.password)isChange[4] = true;
                                    else isChange[4] = false;
                                  });

                                }),
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
                          child: TextField(controller:emailAddress,decoration: InputDecoration(hintText: "Email Address"),readOnly: update,onChanged: (value){
                            setState(() {
                              if(value != _user.emailAddress)isChange[5] = true;
                              else isChange[5] = false;
                            });

                          }),
                        ),),
                      ],
                    ),
                  ),


                  Builder(builder: (BuildContext ncontext){
                    return Center(
                      child:
                      //Register BTN
                      RaisedButton(color: Colors.green[400],focusColor: Colors.grey[400],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(50),bottomRight: Radius.circular(50)),
                        ) ,
                        onPressed: (){
                          bool notUpdated = true;
                          if(firstName.text.isNotEmpty &&lastName.text.isNotEmpty &&
                              emailAddress.text.isNotEmpty &&username.text.isNotEmpty &&
                              password.text.isNotEmpty){
                            User user = new User(firstName.text,lastName.text,address.text,emailAddress.text,username.text,password.text);
                            //dataBaseHelper.deleteAll();
                            // print(password.text + " "+username.text);
                            //dataBaseHelper.insertUser(user);
                            dataBaseHelperUser.getUsersList().then((value) => {
                              if(value.isNotEmpty){
                                for(User userOB in value){
                                  if(_user.username != username.text&&userOB.username!=_user.username){
                                    if(userOB.username == username.text){
                                      _snackBar(context: ncontext,message: "Username is already used.",actionLabel: "okay",duration: 3,textColor: Colors.redAccent[100])
                                    }
                                  }

                                  else{
                                    //ClearFields(),
                                    isChange.forEach((element) {
                                      if(element){
                                        notUpdated = false;
                                        _showMyDialog(context,logoutUpdate: true);
                                        dataBaseHelperUser.updateUserWithPasswordUsername(user,_user.username,_user.password);
                                      }
                                    }),
                                    if(notUpdated)
                                      _snackBar(context: ncontext,message: "There's no data to be update",actionLabel: "okay",duration: 3,textColor: Colors.redAccent[100])
                                    //Navigator.push(context, MaterialPageRoute(builder: (mainContext) => Login()))

                                  }
                                }
                              }
                            });
                          }
                          else {
                            //print(firstName.text+"\n"+lastName.text+"\n"+emailAddress.text+"\n"+username.text+"\n"+password.text+"\n");
                            _snackBar(context: ncontext,message: "Please fill it all up.",actionLabel: "okay",duration: 3,textColor: Colors.redAccent[100]);
                          }
                        },

                        child: Container(
                          height: 60,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Update",style: TextStyle(color: Colors.white),textAlign: TextAlign.center,),
                              Icon(Icons.update,size: 20,color: Colors.white,)
                            ],),
                        ),),);
                  }),
                  //ResetBTN


                ],),),
            )]),);
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


  Future<void> _showMyDialog(BuildContext mainContext,{bool logoutUpdate = false}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return WillPopScope(onWillPop: () async => false,
          child: AlertDialog(
            title: Text('Logout'),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Are you sure would you like to logout?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Confirm'),
                onPressed: () {
                  //Navigator.of(context).pop();
                  Navigator.push(mainContext, MaterialPageRoute(builder: (mainContext) => Login()));
                },
              ),
              if(!logoutUpdate)
                TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
            ],
          ),);
      },
    );
  }
}
