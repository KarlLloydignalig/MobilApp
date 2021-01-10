import 'dart:io';
import 'dart:math';

import 'package:auto_complete_search/auto_complete_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:paraiso/Models/places_model.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:paraiso/Pages/HomePage/me_page.dart';
import 'package:paraiso/Pages/HomePage/place_list_page.dart';
import 'package:paraiso/Pages/Login_Registration/login.dart';
import 'package:paraiso/Pages/PlacePage/place_page.dart';
import 'package:paraiso/Utils/database_helper_place.dart';
import 'package:paraiso/Utils/database_helper_user.dart';
import 'package:paraiso/Utils/my_colors.dart';
import 'package:recase/recase.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:paraiso/Utils/app_builder.dart';

class Home extends StatefulWidget{
  final User _user;
  final List<Place> _places;
  Home(this._user,this._places);
  @override
  HomeState createState() => HomeState(_user,_places);
}
class HomeState extends State<Home>{
  HomeState instance;

  User _user;
  List<Place> _places;
  Place selectedNotSpot;
  HomeState(this._user,this._places);
  DataBaseHelperPlace dataBaseHelperPlace = DataBaseHelperPlace();
  DataBaseHelperUser dataBaseHelperUser = DataBaseHelperUser();
  GlobalKey key = new GlobalKey<AutoCompleteSearchFieldState<Place>>();
  final Color iconColor = BlueSubmerge.withAlpha(255);
  final Color userInfoTextColor = Colors.white;
  double contentSize;
  List<bool> _selections = List.generate(4, (_) => false);
  TextEditingController place;
  TextEditingController search  = new TextEditingController();
  ScrollController mainScrollView = new ScrollController();

  String currentSelectedTag = 'all';
  String currentText = "";
  int heart = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    instance = this;

  }
  void refresh(){
    AppBuilder.of(context).rebuild();
  }
  @override
  Widget build(BuildContext context) {
    contentSize = MediaQuery.of(context).size.height;
      return FutureBuilder<List<Place>>(
          future: dataBaseHelperPlace.getPlaceList(),
          builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot){
            if(snapshot.hasData){
              _places = snapshot.data;
              return new WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  appBar: AppBar(
                      toolbarHeight: 50,
                      automaticallyImplyLeading: false,
                      titleSpacing: 0,
                      title:Container(
                        //margin: EdgeInsets.only(top: 50),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Material(
                              elevation: 0,
                              child: AutoCompleteSearchField(
                                key: key,
                                suggestions: _places.toSet().toList(),
                                controller: search,
                                submitOnSuggestionTap: true,
                                clearOnSubmit: false,
                                itemSorter: (Place a, Place b) =>
                                    a.name.toLowerCase().compareTo(b.name.toLowerCase()),

                                itemBuilder: (context, place) => Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(

                                          margin: EdgeInsets.only(left: 10,right: 10),
                                          child: Image.asset(place.coverPhotoPath,height: 70,width: 70,)),
                                      Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: MediaQuery.of(context).size.width-150,
                                              child: Text(
                                                  "Php."+place.fees.toString(),
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: SunGlow.withAlpha(255)),
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width-150,
                                              child: Text(
                                                  place.name,
                                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),

                                            Container(
                                              width: MediaQuery.of(context).size.width-150,
                                              child: Text(
                                                  place.location,
                                                  softWrap: true,
                                                  overflow: TextOverflow.ellipsis
                                              ),
                                            ),
                                            if(place.rating!=null)
                                              SmoothStarRating(
                                                rating: place.rating,
                                                isReadOnly: false,
                                                size: 25,
                                                color: Colors.yellow,
                                                borderColor: Colors.yellow[700],
                                                filledIconData: Icons.star,
                                                halfFilledIconData: Icons.star_half,
                                                defaultIconData: Icons.star_border,
                                                starCount: 5,
                                                allowHalfRating: true,
                                                spacing: 2.0,
                                              ),
                                          ]),

                                    ],
                                  ),
                                ),
                                itemSubmitted: (Place place) async {
                                  var user = await dataBaseHelperUser.getUser(_user.username, _user.password);
                                  _user = user.first;
                                  setState(() {
                                    search.text = place.name;
                                    if(place.isSpot == 1){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage(place, _user)));
                                    }
                                    else{
                                      selectedNotSpot = place;
                                    }

                                  });
                                },
                                itemFilter: (suggestion, input)
                                => suggestion.name.toLowerCase().contains(input.toLowerCase()) ||
                                    suggestion.cityName.toString().toLowerCase().contains(input.toLowerCase()) ||
                                    suggestion.location.toString().toLowerCase().contains(input.toLowerCase()),

                                decoration: InputDecoration(
                                    labelText: "Search Adventure",
                                    prefixIcon: Icon(Icons.search,color: BlueSubmerge.withAlpha(255),),
                                    border: InputBorder.none,
                                    hintText: "Try \"Cagayan de Oro\"",
                                    suffixIcon: IconButton(icon: Icon(Icons.home),onPressed: (){
                                      setState(() {
                                        selectedNotSpot = null;
                                        search.clear();
                                      });
                                    },)

                                ),
                              ),
                            ),
                          ],
                        ),
                      )

                  ),
                  // backgroundColor: BlueSubmerge.w,
                  body: CustomScrollView(
                    controller: mainScrollView,
                    slivers: <Widget>[
                      SliverAppBar(
                          shadowColor: Colors.white.withAlpha(0),
                          expandedHeight: _places.length>0 ? 250:MediaQuery.of(context).size.height,
                          automaticallyImplyLeading: false,
                          pinned: true,
                          titleSpacing: 0,
                          floating: true,
                          toolbarHeight: 100,
                          backgroundColor: ScubaBlue.withAlpha(200),
                          title: Container(
                            margin: EdgeInsets.only(top: 5),
                            height: 50,
                            width: double.infinity,
                            child: Material(
                              color: Colors.white.withAlpha(0),
                              elevation: 0,
                              child:selectedNotSpot!=null?
                              Container(
                                  alignment: Alignment.center,
                                  width: double.infinity,
                                  color: BlueSubmerge.withAlpha(150),
                                  child: Text(selectedNotSpot.cityName,style: TextStyle(fontSize: 25,color: Colors.white,fontWeight: FontWeight.bold),)
                              )
                                  :Image.asset("assets/logo.png",fit: BoxFit.contain,height: 15,alignment: Alignment.bottomCenter,),
                            ),
                          ),
                          bottom: PreferredSize(
                            // Add this code
                              preferredSize: Size.fromHeight(120),      // Add this code
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 0,right: 0),
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: ScubaBlue.withAlpha(255),
                                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),topLeft: Radius.circular(50)),
                                    ),

                                    child:Container(
                                      //width: double.infinity,
                                      alignment: Alignment.center,
                                      child: ToggleButtons(
                                        borderColor: Colors.white.withAlpha(0),
                                        borderRadius: BorderRadius.only(topLeft:Radius.circular(50),topRight:Radius.circular(50) ),
                                        borderWidth: .5,

                                        selectedBorderColor: BlueSubmerge.withAlpha(0),
                                        selectedColor: SunGlow.withAlpha(255),
                                        color: Colors.white,
                                        renderBorder: true,
                                        children: <Widget>[
                                          toggleButton("Sleep", Icons.hotel),
                                          toggleButton("Eat", Icons.local_dining),
                                          toggleButton("Relax", Icons.self_improvement),
                                          toggleButton("Experience", Icons.tour),

                                        ],
                                        onPressed: (int index) {
                                          setState(() {
                                            if(_selections[index]){
                                              _selections=List.filled(_selections. length, false);
                                              _selections[index]=false;
                                            }
                                            else{
                                              _selections=List.filled(_selections. length, false);
                                              _selections[index]=true;
                                            }
                                            currentSelectedTag = selectedTag();
                                            //_selections[index] = !_selections[index];
                                          });
                                        },
                                        isSelected: _selections,
                                      ),
                                    ),
                                  ),
                                ],
                              )         // Add this code
                          ),
                          flexibleSpace: Stack(
                            children: [
                              Positioned.fill(
                                  child:selectedNotSpot!=null? Image.file(
                                    File(selectedNotSpot.getGallery().split(',')[Random().nextInt(selectedNotSpot.getGallery().split(',').length)]),
                                    fit: BoxFit.cover,
                                  ): Image.asset(
                                    "assets/backgrounds/bg2.png",
                                    fit: BoxFit.cover,
                                  )),
                              FlexibleSpaceBar(
                                titlePadding: EdgeInsets.only(top: 0),
                                centerTitle: false,

                                background:  selectedNotSpot!=null? Image.file(File(selectedNotSpot.coverPhotoPath),fit: BoxFit.cover):Image.asset("assets/backgrounds/bg3.png",fit: BoxFit.cover,),
                                title:Container(
                                  padding: EdgeInsets.only(top:0,bottom: 40,left: 30),
                                  alignment: Alignment.center,
                                  child:Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(_user.username.toString().titleCase,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                              //Icon(Icons.login_rounded,color: Colors.white,)
                                            ],
                                          ),
                                          Text(_user.firstName.toString().titleCase+" "+_user.lastName.toString().titleCase,style: TextStyle(fontSize: 13)),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),

                              ),
                            ],)
                      ),
                      //RATED
                      if(_places.isNotEmpty&&currentSelectedTag=='all')
                        featuredPlaces("Most rated places",featureInt:1,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='all')
                        featuredPlaces("Most popular places",featureInt:2,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='all')
                        featuredPlaces("All",featureInt:3,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),

                      if(_places.isNotEmpty&&currentSelectedTag=='Sleep')
                        featuredPlaces("Most rated Hotel",featureInt:1,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Sleep')
                        featuredPlaces("Most popular Hotel",featureInt:2,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Sleep')
                        featuredPlaces("All",featureInt:3,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),

                      if(_places.isNotEmpty&&currentSelectedTag=='Eat')
                        featuredPlaces("Most rated Resto",featureInt:1,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Eat')
                        featuredPlaces("Most popular Resto",featureInt:2,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Eat')
                        featuredPlaces("All Resto",featureInt:3,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),

                      if(_places.isNotEmpty&&currentSelectedTag=='Relax')
                        featuredPlaces("Most rated relaxation place",featureInt:1,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Relax')
                        featuredPlaces("Most popular relaxation place",featureInt:2,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Relax')
                        featuredPlaces("All relaxation place",featureInt:3,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),

                      if(_places.isNotEmpty&&currentSelectedTag=='Experience')
                        featuredPlaces("Most rated Adventures",featureInt:1,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Experience')
                        featuredPlaces("Most popular Adventures",featureInt:2,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),
                      if(_places.isNotEmpty&&currentSelectedTag=='Experience')
                        featuredPlaces("All Adventures",featureInt:3,city: selectedNotSpot!=null? selectedNotSpot.cityName:'',tag:selectedTag() ),

                      // if(selectedTag() == 'Sleep')
                      //   featuredPlaces("Hotels",featuredType: 3,city: selectedNotSpot!=null? selectedNotSpot.cityName:null,tag:selectedTag() ),
                      // if(selectedTag() == 'Eat')
                      //   featuredPlaces("Kaon ta bai!",featuredType: 3,city: selectedNotSpot!=null? selectedNotSpot.cityName:null,tag:selectedTag()),
                      // if(selectedTag() == 'Relax')
                      //   featuredPlaces("Ahmm nice!",featuredType: 3,city: selectedNotSpot!=null? selectedNotSpot.cityName:null,tag:selectedTag()),
                      // if(selectedTag() == 'Experience')
                      //   featuredPlaces("Adventuressss!",featuredType: 3,city: selectedNotSpot!=null? selectedNotSpot.cityName:null,tag:selectedTag()),


                    ],
                  ),
                  bottomNavigationBar: BottomAppBar(
                    shape: AutomaticNotchedShape(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(100), bottomRight: Radius.circular(100))),
                      //RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(100)))
                    ),
                    clipBehavior: Clip.antiAlias,
                    color: ScubaBlue.withAlpha(255),
                    child: Container(
                      width: double.infinity,
                      height: 50,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          flatButton(Icons.person,Colors.white,text: Text("Me",style: TextStyle(color: Colors.white),),statefulWidget: Me(_user,_places)),
                          flatButton(Icons.flag,Colors.white,text: Text("Visited",style: TextStyle(color: Colors.white)),statefulWidget:
                          PlaceListPlace(_user,_places,_user.visitedPlace,"You visited this place",_user.visitedPlace.toString().split('|').length)),
                          flatButton(Icons.fact_check,Colors.white,text: Text("Wish List",style: TextStyle(color: Colors.white)),statefulWidget:
                          PlaceListPlace(_user,_places,_user.wishPlace,"You wished this place",_user.wishPlace.toString().split('|').length)),
                          //flatButton(Icons.local_activity,Colors.white,text: Text("Activity",style: TextStyle(color: Colors.white)))
                        ],
                      ),
                    ),

                  ),

                ),

              );
            }
            else return Center(child: CircularProgressIndicator());
          }
      );

  }
  SliverToBoxAdapter featuredPlaces(String tittle,{int featureInt = 1,String city = '',String tag = ''}){
    List<Place> places = new List<Place>();
    if(city.isNotEmpty){
      for(Place _place in _places){
        if(_place.cityName == city){
          switch(featureInt){
            case 1: if(_place.rating!=null){
              if(_place.rating>4&&tag == _place.tag){
                places.add(_place);
              }
              else if(_place.rating>4&&tag == 'all'){
                places.add(_place);
              }
            }
            break;
            case 2: if(_place.commentCount!=null){
              if(_place.commentCount>4&&tag == _place.tag){
                places.add(_place);
              }
              else if(_place.commentCount>4&&tag == 'all'){
                places.add(_place);
              }
            }
            break;
            case 2: if(_place.commentCount!=null){
              if(_place.commentCount>4&&tag == _place.tag){
                places.add(_place);
              }
              else if(_place.commentCount>4&&tag == 'all'){
                places.add(_place);
              }
            }
            break;
            case 3:
              if(tag == _place.tag){
                places.add(_place);
              }
              else if(tag == 'all'){
                places.add(_place);
              }
              break;
          }

        }
      }
    }
    if(!city.isNotEmpty) {
      for (Place _place in _places) {
        switch (featureInt) {
          case 1:
            if (_place.rating != null) {
              if (_place.rating > 4 && tag == _place.tag) {
                places.add(_place);
              }
              else if (_place.rating > 4 && tag == 'all') {
                places.add(_place);
              }
            }
            break;
          case 2:
            if (_place.commentCount != null) {
              if (_place.commentCount > 4 && tag == _place.tag) {
                places.add(_place);
              }
              else if (_place.commentCount > 4 && tag == 'all') {
                places.add(_place);
              }
            }
            break;
          case 2:
            if (_place.commentCount != null) {
              if (_place.commentCount > 4 && tag == _place.tag) {
                places.add(_place);
              }
              else if (_place.commentCount > 4 && tag == 'all') {
                places.add(_place);
              }
            }
            break;
          case 3:
          //print(_place.tag+" "+tag);
            if (tag == _place.tag) {
              places.add(_place);
            }
            else if (tag == 'all') {
              places.add(_place);
            }
            break;
        }
      }
    }

    return places.length<=0?SliverToBoxAdapter(

    ):
    SliverToBoxAdapter(
        child: Container(
          margin: EdgeInsets.only(left: 10,top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tittle,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
              Container(
                  height: 300,
                  child: featureInt==3?
                  GridView.count(
                    mainAxisSpacing: 10,
                    childAspectRatio: .65,
                    crossAxisCount: 2,
                    children: [
                      for(Place p in places)
                        listItem(p)
                    ],
                  ):ListView(
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      for(Place p in places)
                        listItem(p)
                    ],)
              ),
            ],
          ),
        )
    );
  }

  Widget listItem(Place place){

    int j = 5;
    return Container(
        width: 200,
        child: GestureDetector(
          onTap: () async{
            var user = await dataBaseHelperUser.getUser(_user.username, _user.password);
            _user = user.first;
            //print(_user.heartPlace);
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage(place,_user)));
          },
          child: Card(
            child:Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,

              children: [
                Image.file(
                  File(place.coverPhotoPath),
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  height: 150 ,
                ),

                Container(
                  margin: EdgeInsets.only(top: 5,bottom: 0,left: 6,right: 6),
                  child: Column(
                    children: [
                      Container(
                          alignment: Alignment.centerLeft,
                          child: Text("Php."+place.fees.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: SunGlow.withAlpha(255) ),)),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: SmoothStarRating(
                          rating: place.rating!=null ? place.rating : 0,
                          isReadOnly: false,
                          size: 20,
                          color: Colors.yellow,
                          borderColor: Colors.yellow[700],
                          filledIconData: Icons.star,
                          halfFilledIconData: Icons.star_half,
                          defaultIconData: Icons.star_border,
                          starCount: 5,
                          allowHalfRating: true,
                          spacing: 2.0,
                        ),
                      ),
                      Container(alignment: Alignment.topLeft,
                        child:Text(place.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16),overflow: TextOverflow.ellipsis),),
                      Container(alignment: Alignment.topLeft,
                        child:Text(place.cityName,style: TextStyle(),),),
                      Container(
                        height: 10,
                        alignment: Alignment.topLeft,
                        child:Text(place.description,style: TextStyle(fontSize: 10,),overflow: TextOverflow.ellipsis,),),
                    ],),),


                Container(
                  margin: EdgeInsets.only(bottom: 0,left: 6,right: 6,top: 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        margin: EdgeInsets.all(5),

                        child: Column(
                          children: [
                            Icon(Icons.favorite,color: Colors.blue,),
                            Text(place.heartCount.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Icon(Icons.mode_comment,color: Colors.blue[300],),
                            Text(place.commentCount.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(5),
                        child: Column(
                          children: [
                            Icon(Icons.flag,color: Colors.blue[300],),
                            Text(place.visitedCounter.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 5,bottom: 5,left: 3,right: 3),
                        child: Column(
                          children: [
                            Image.asset('assets/noun_wish list.png',width: 25,height: 25,color:  Colors.blue[300],),
                            Text(place.wishCount.toString(),style: TextStyle(fontSize: 10,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ],),)
              ],
            ),
          ),
        )
    );
  }

  Container toggleButton(String name,IconData icon){
    return Container(
      width: 102,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        //mainAxisSize: MainAxisSize.max,
        children:[
          Icon(icon,),
          Text(name,style: TextStyle(fontWeight: FontWeight.bold),)
        ] ,),
    );
  }

  FlatButton flatButton(IconData icon,Color colors,{Text text,Function onPressed,StatefulWidget statefulWidget}){
    return FlatButton(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,color: colors,),
            text
          ],),
        onPressed: (){
          setState(() {
            if(onPressed!=null){
              onPressed();
            }
            if(statefulWidget!=null){
              Navigator.push(context, MaterialPageRoute(builder: (context) => statefulWidget));
            }
          });
        });
  }

  Future<void> _showMyDialog(BuildContext mainContext) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
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
                Navigator.of(context).pop();
                Navigator.push(mainContext, MaterialPageRoute(builder: (mainContext) => Login()));
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
  String selectedTag(){
    if(_selections[0])return 'Seep';
    if(_selections[1])return 'Eat';
    if(_selections[2])return 'Relax';
    if(_selections[3])return 'Experience';
    if(!_selections[0]&&
        !_selections[1]&&
        !_selections[2]&&
        !_selections[3]){
      return 'all';
    }

    return 'all';
  }

}

