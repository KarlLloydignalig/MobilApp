import 'dart:io';
import 'dart:math';


import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:paraiso/Models/places_model.dart';
import 'package:paraiso/Pages/HomePage/place_list_page.dart';
import 'package:recase/recase.dart';
import 'package:paraiso/Utils/database_helper_place.dart';
import 'package:paraiso/Models/chat_model.dart';
import 'package:paraiso/Utils/database_chat_helper.dart';
import 'package:paraiso/Utils/my_colors.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:paraiso/Pages/PlacePage/place_selected_image.dart';
import 'package:paraiso/Utils/database_helper_user.dart';
import 'package:paraiso/Pages/HomePage/home.dart';


class PlacePage extends StatefulWidget{
  final Place _place;
  final User _user;


  PlacePage(this._place, this._user);

  @override
  PlacePageState createState() => PlacePageState(_place,_user);
}

class PlacePageState extends State<PlacePage>{
  Place _place;
  User _user;


  PlacePageState(this._place, this._user);

  List<Chat> _chats;
  List<Image> images = new List<Image>();
  List<Color> iconColors = new List<Color>();
  String fullPlaceID;

  DataBaseHelperChat dataBaseHelperChat = DataBaseHelperChat();
  DataBaseHelperPlace dataBaseHelperPlace = DataBaseHelperPlace();
  DataBaseHelperUser dataBaseHelperUser = DataBaseHelperUser();
  TextEditingController comment = new TextEditingController();
  int j = 5;
  double rating = 0.0;

  bool isHearted = false;
  bool isVisited = false;
  bool isWish = false;
  @override
  void initState()  {
    // TODO: implement initState
    super.initState();

    // _user.heartPlace = '';
    // _user.commentedPlace = "";
    // _user.visitedPlace = '';
    // _place.commentCount = 0;
    // _place.heartCount = 0;
    // _place.visitedCounter = 0;
    // _place.rating = 0;
    // _place.wishCount = 0;
    // dataBaseHelperPlace.updatePlace(_place, _place);
    // dataBaseHelperUser.updateUser(_user);
    // dataBaseHelperChat.deleteAll();
    fullPlaceID = _place.id.toString()+"(-)"+_place.name;
    loadImages();
    iconColors.add(Colors.white);
    iconColors.add(Colors.white);
    iconColors.add(Colors.white);
    iconColors.add(Colors.white);
    if(_user.commentedPlace!=null){

      for(String commented in _user.commentedPlace.toString().split('|')){
        //print(commented+" - "+ fullPlaceID);
        if(commented == (fullPlaceID)){
          setState(() {
            iconColors[1] = ScubaBlue.withAlpha(255);
          });
          break;
        }
      }
    }
    if(_user.heartPlace!=null){
      //print(_user.heartPlace);
      for(String hearted in _user.heartPlace.toString().split('|')){
        if(hearted == (fullPlaceID)){
          setState(() {
            iconColors[0] = ScubaBlue.withAlpha(255);
            isHearted = true;
          });
          break;
        }
      }
    }
    if(_user.visitedPlace!=null){
      //print(_user.heartPlace);
      for(String hearted in _user.visitedPlace.toString().split('|')){
        if(hearted == (fullPlaceID)){
          setState(() {
            iconColors[2] = ScubaBlue.withAlpha(255);
            isVisited = true;
          });
          break;
        }
      }
    }
    if(_user.wishPlace!=null){
      //print(_user.heartPlace);
      for(String hearted in _user.wishPlace.toString().split('|')){
        if(hearted == (fullPlaceID)){
          setState(() {
            iconColors[3] = ScubaBlue.withAlpha(255);
            isWish = true;
          });
          break;
        }
      }
    }
  }
  Future<bool> _onBackPressed(){
    setState(() {
      isHearted = false;
      isVisited = false;
      isWish = false;
    });
    return Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) {
          return Home(_user, null);
        },
      ),
          (Route<dynamic> route) => false,
    );
  }
  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        bottomNavigationBar: TextButton(child: Text("Make a review."),onPressed: (){
          setState(() {
            bool isDone = false;
            //print(isDone.toString()+" --------- "+_user.username);
            for(Chat chat in _chats){
              if(chat.posterName == _user.username){
                isDone = true;
                break;
              }
            }

            if(isDone){
              _showMyDialog(context,true);
            }
            else{
              _showMyDialog(context,false);
            }

          });
        },),
        body: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                  automaticallyImplyLeading: false,
                  expandedHeight: 500,
                  pinned: true,
                  titleSpacing: 0,
                  floating: true,
                  bottom: PreferredSize(
                    preferredSize: Size.fromHeight(150),
                    child: Container(
                      height: 130,
                      padding: EdgeInsets.only(left: 10,top: 10),

                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: BlueSubmerge.withAlpha(100),

                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Row(
                            children: [
                              Text(_place.name.toString().titleCase,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold,color: Colors.white),),
                              //Icon(Icons.login_rounded,color: Colors.white,)
                            ],
                          ),
                          Text(_place.cityName.toString().titleCase,style: TextStyle(fontSize: 13,color: Colors.white)),
                          SizedBox(height: 10,),
                          SmoothStarRating(
                            rating: _place.rating!=null ? _place.rating:0,
                            isReadOnly: true,
                            size: 24,
                            color: Colors.yellow,
                            borderColor: Colors.yellow[700],
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star_border,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                          ),
                          Container(
                            width: 130,
                            child: Row(

                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon:Icon(Icons.favorite,color:iconColors[0]) ,
                                        onPressed: () {

                                          setState(() {
                                            if(isHearted){
                                              _user.heartPlace = _user.heartPlace.toString().replaceAll(fullPlaceID+"|",'');
                                              //print(_user.heartPlace);
                                              iconColors[0] = Colors.white;
                                              isHearted = false;
                                              _place.heartCount--;

                                            }
                                            else{
                                              _user.heartPlace = _user.heartPlace==null? '': _user.heartPlace;
                                              _user.heartPlace+=fullPlaceID+"|";
                                              //print( _user.heartPlace);
                                              iconColors[0] = ScubaBlue.withAlpha(255);
                                              isHearted = true;
                                              _place.heartCount++;

                                            }
                                            dataBaseHelperPlace.updatePlace(_place, _place);
                                            dataBaseHelperUser.updateUser(_user);

                                          });
                                        },),
                                    ),
                                    Text(_place.heartCount!=null? _place.heartCount.toString():0,style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                          padding: EdgeInsets.all(0),
                                          icon:Icon(Icons.mode_comment,color:iconColors[1]),
                                          onPressed: (){

                                          }),
                                    ),
                                    Text(_place.commentCount!=null? _place.commentCount.toString():0,style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: IconButton(
                                        padding: EdgeInsets.all(0),
                                        icon:Icon(Icons.flag,color:iconColors[2]) ,
                                        onPressed: ()async{
                                          setState(() {
                                            if(isVisited){
                                              _user.visitedPlace = _user.visitedPlace.toString().replaceAll(fullPlaceID+"|",'');
                                              //print(_user.heartPlace);
                                              iconColors[2] = Colors.white;
                                              isVisited = false;
                                              _place.visitedCounter--;

                                            }
                                            else{
                                              _user.visitedPlace = _user.visitedPlace==null? '': _user.visitedPlace;
                                              _user.visitedPlace+=fullPlaceID+"|";
                                              //print( _user.visitedPlace);
                                              iconColors[2] = ScubaBlue.withAlpha(255);
                                              isVisited = true;
                                              _place.visitedCounter++;

                                            }
                                            dataBaseHelperPlace.updatePlace(_place, _place);
                                            dataBaseHelperUser.updateUser(_user);
                                          });


                                        },),
                                    ),
                                    Text(_place.visitedCounter!=null? _place.visitedCounter.toString():0,style: TextStyle(color: Colors.white),)
                                  ],
                                ),
                                Column(
                                  children: [
                                    SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: GestureDetector(
                                          onTap: (){
                                            setState(() {
                                              if(isWish){
                                                _user.wishPlace = _user.wishPlace.toString().replaceAll(fullPlaceID+"|",'');
                                                //print(_user.heartPlace);
                                                iconColors[3] = Colors.white;
                                                isWish = false;
                                                _place.wishCount--;

                                              }
                                              else{
                                                _user.wishPlace = _user.wishPlace==null? '': _user.wishPlace;
                                                _user.wishPlace+=fullPlaceID+"|";
                                                //print( _user.heartPlace);
                                                iconColors[3] = ScubaBlue.withAlpha(255);
                                                isWish = true;
                                                _place.wishCount++;

                                              }
                                              dataBaseHelperPlace.updatePlace(_place, _place);
                                              dataBaseHelperUser.updateUser(_user);
                                            });
                                          },
                                          child: Image.asset('assets/noun_wish list.png',
                                            width: 10,
                                            height: 10,
                                            color: iconColors[3],
                                            isAntiAlias: true,
                                          ),
                                        )
                                    ),
                                    Text(_place.wishCount!=null? _place.wishCount.toString():0,style: TextStyle(color: Colors.white),)
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                  ),
                  flexibleSpace: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.file(File(_place.getGallery().split(',')[new Random().nextInt(_place.getGallery().split(',').length-1)]),fit: BoxFit.cover,),
                      ),
                      FlexibleSpaceBar(
                        titlePadding: EdgeInsets.only(top: 0),
                        centerTitle: false,
                        background: Image.file(File(_place.coverPhotoPath),fit: BoxFit.cover,),

                      ),
                    ],)
              ),
              SliverToBoxAdapter(
                child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Description",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                        Text(_place.location.toString().titleCase,style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),),
                        Container(
                          //height: 200,
                          margin: EdgeInsets.all(5),
                          child: Text(_place.description,style: TextStyle(fontSize: 12),),
                        )
                      ],
                    )),
              ),
              SliverToBoxAdapter(
                child: Container(
                    height: 300,
                    width: double.infinity,
                    child: CarouselSlider(
                      options: CarouselOptions(
                          height: double.infinity,
                          autoPlayInterval: Duration(seconds: 10),
                          viewportFraction: 1,
                          autoPlay: true,
                          enlargeCenterPage: false
                      ),
                      items: [
                        for(String path in _place.getGallery().split(','))

                          GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceSelectedImage(path,_place.getGallery().split(','))));
                            },
                            child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                ),
                                child: Image.file(File(path))
                            ),),
                        GestureDetector(
                          onTap: (){
                            String paths = _place.getGallery()+_place.coverPhotoPath;
                            Navigator.push(context, MaterialPageRoute(builder: (context) => PlaceSelectedImage(_place.coverPhotoPath,paths.split(','))));
                          },
                          child: Image.file(File(_place.coverPhotoPath)),
                        )

                      ],)
                ),
              ),


              SliverToBoxAdapter(
                  child:SingleChildScrollView(
                      child: FutureBuilder<List<Chat>>(
                        future: dataBaseHelperChat.getChatListWhere(_place.id.toString()),
                        builder: (BuildContext context, AsyncSnapshot<List<Chat>> snapshot){
                          //print(snapshot.data.length);
                          if(snapshot.hasData){
                            _chats = snapshot.data;
                            return Container(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                    for(Chat chats in snapshot.data)
                                      Container(
                                        //margin: EdgeInsets.only(bottom: 10,left: 10,right: 10),
                                        padding: EdgeInsets.all(5),
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          //color: ScubaBlue.withAlpha(100),

                                          //borderRadius: BorderRadius.only(bottomRight:Radius.circular(40) ,bottomLeft: Radius.circular(40)),
                                            border: Border(bottom: BorderSide(width: .1))
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(chats.posterName+":",style:TextStyle(fontWeight: FontWeight.bold,color:  BlueSubmerge.withAlpha(200)),),
                                              Text(chats.message,style:TextStyle(color: Colors.grey[900])),
                                              SmoothStarRating(
                                                rating: chats.rated,
                                                isReadOnly: false,
                                                size: 25,
                                                color: Colors.yellow,
                                                borderColor: chats.rated==0? Colors.yellow.withAlpha(0):Colors.yellow[700],
                                                filledIconData: Icons.star,
                                                halfFilledIconData: Icons.star_half,
                                                defaultIconData: Icons.star_border,
                                                starCount: 5,
                                                allowHalfRating: true,
                                                spacing: 2.0,
                                              )
                                            ],
                                          ),
                                        ),
                                      ),

                                  ]
                              ),
                            );

                          }
                          else return Center(child: Text("No Comments"));
                        },
                      )
                  )
              )
            ]
        ),

      ),);
  }
  void loadImages() {
    setState(() {
      for(String path in _place.getGallery().split(',')){
        images.add(
            Image.file(File(path),
              fit: BoxFit.cover,
              scale: 0.1,
              isAntiAlias: true,
            ));
      }
    });
  }

  Future<void> _showMyDialog(BuildContext mainContext,bool isDoneRating) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('You Review.'),
              Text('You can only rate once.',style: TextStyle(fontSize: 12),),
            ],
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        TextField(
                          controller: comment,
                          decoration: InputDecoration(
                            labelText: "Write review, place go brrrrrrrr",
                            hintText: "What?...",)
                          ,),
                        if(!isDoneRating)
                          Center(
                            child: SmoothStarRating(
                              rating: rating,
                              isReadOnly: false,
                              size: 40,
                              filledIconData: Icons.star,
                              halfFilledIconData: Icons.star_half,
                              defaultIconData: Icons.star_border,
                              starCount: 5,
                              allowHalfRating: true,
                              spacing: 2.0,
                              onRated: (value) {
                                rating = value;
                                // print("rating value dd -> ${value.truncate()}");
                              },
                            ),
                          ),
                      ]
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Post'),
              onPressed: () async{
                Navigator.of(context).pop();
                setState(() {
                  double average = 0,count = 0;
                  //dataBaseHelperChat.deleteAll();
                  if(comment.text.isNotEmpty){
                    dataBaseHelperChat.insertChat(new Chat(_place.id.toString(),_user.username,comment.text,"This is details",rating));
                    //print(fullPlaceID);
                    _user.commentedPlace = _user.commentedPlace==null? '': _user.commentedPlace;
                    _user.commentedPlace += fullPlaceID+'|';
                    dataBaseHelperUser.updateUser(_user);


                    iconColors[1] = ScubaBlue.withAlpha(255);

                    if(!isDoneRating){
                      _chats.forEach((element) {
                        if(element.rated!= null){
                          average+=element.rated;
                          count++;
                        }

                      });
                      _place.rating = (average/count);
                      //AppBuilder.of(context).rebuild();(_place.rating);
                    }

                    _place.commentCount++;
                    dataBaseHelperPlace.updatePlace(_place, _place);
                    comment.clear();
                  }
                  else{

                  }

                });
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

}