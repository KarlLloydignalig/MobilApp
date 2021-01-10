import 'dart:io';

import 'package:flutter/material.dart';
import 'package:paraiso/Pages/PlacePage/place_page.dart';
import 'package:paraiso/Utils/my_colors.dart';
import 'package:paraiso/Models/places_model.dart';
import 'package:paraiso/Models/users_model.dart';
import 'package:recase/recase.dart';
import 'package:paraiso/Utils/database_helper_place.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
class PlaceListPlace extends StatefulWidget{
  final User _user;
  final List<Place> _places;
  final String _placeString;
  final String _tittle;
  final int _placeCount;
  PlaceListPlace(this._user,this._places,this._placeString,this._tittle,this._placeCount);

  @override
  PlaceListPlaceState createState() => PlaceListPlaceState(_user,_places,this._placeString,_tittle,_placeCount);
}

class PlaceListPlaceState extends State<PlaceListPlace>{
  DataBaseHelperPlace dataBaseHelperPlace = DataBaseHelperPlace();
  final User _user;
  final List<Place> _places;
  final String _placeString;
  final int _placeCount;
  String _tittle = '';
  List<Place> visitedPlaces = new List<Place>();
  PlaceListPlaceState(this._user,this._places,this._placeString,this._tittle,this._placeCount);

  @override
  void initState() {
    super.initState();
    print(_placeCount);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Text(_tittle+(_placeCount-1==1?'':'s'),style: TextStyle(color: Colors.black87),),
        ),
        body: GestureDetector(
          onTap: (){

          },
          child:Container(
            child: GridView.count(
              childAspectRatio: 0.65,
              crossAxisCount: 2,
              children: [
                if(_placeString!=null)
                  for(String pl in _placeString.split('|'))
                    if(pl.split('(-)').length>1)
                      placeBuilder(int.parse(pl.split('(-)')[0]),pl.split('(-)')[1])
              ],
            ),
          ) ,
        )
    );
  }

  FutureBuilder placeBuilder(int id,String name){
    return FutureBuilder<List<Place>>(
        future: dataBaseHelperPlace.getPlaceIndividual(id, name),
        builder: (BuildContext context, AsyncSnapshot<List<Place>> snapshot){
          if(snapshot.hasData){
            return listItem(snapshot.data.first);
          }
          else return Center(child: CircularProgressIndicator());
        }
    );
  }
  Widget listItem(Place place){

    int j = 5;
    return Container(
        width: 200,
        child: GestureDetector(
          onTap: () {
            //print(_user.heartPlace);
            Navigator.push(context, MaterialPageRoute(builder: (context) => PlacePage(place, _user)));

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
                          isReadOnly: true,
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
}
