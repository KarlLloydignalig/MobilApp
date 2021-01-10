import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:paraiso/Models/places_model.dart';


class DataBaseHelperPlace{
  static DataBaseHelperPlace _dataBaseHelper;
  static Database _dataBase;
  String tableName = 'places_table'
  ,cPlaceName = 'name'
  ,cLocation = 'location'
  ,cDescription = 'description'
  ,cId = 'id'
  ,cRating = 'rating'
  ,cCoverPhoto = 'coverPhoto'
  ,cTag = 'tag'
      //added values
  ,cComments = 'comments'
  ,cCommentCount = 'commentCount'
  ,cHeartCount = 'heartCount'
  ,cWishCount = 'wishCount'
  ,cFees = 'fees'
  ,cCityName = 'cityName'
  ,cIsSpot = 'isSpot'
  ,cVisitorCounter = 'visitorCounter'
  ,cPhotoGallery = 'photoGallery';


  DataBaseHelperPlace._createInstance();

  factory DataBaseHelperPlace(){
    if(_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelperPlace._createInstance();
    }
    return _dataBaseHelper;
  }

  Future<Database> get database async{
    if(_dataBase == null){
      _dataBase = await initDatabase();
    }
    return _dataBase;
  }

  Future<Database> initDatabase() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'places.db';
    var userDatabase = await openDatabase(path,version: 1, onCreate: _createDB);
    return userDatabase;
  }
  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($cPlaceName TEXT,$cLocation TEXT,$cTag TEXT,'
        '$cDescription TEXT,$cIsSpot INTEGER,$cRating DOUBLE,'
        //added values
        '$cCommentCount INTEGER,$cHeartCount INTEGER,$cWishCount INTEGER'
        ',$cFees DOUBLE,$cComments TEXT,$cCityName TEXT,'
        '$cId INTEGER PRIMARY KEY AUTOINCREMENT'
        ',$cCoverPhoto TEXT,$cPhotoGallery TEXT,$cVisitorCounter INTEGER)');
  }


  //Fetch
  Future<List<Map<String,dynamic>>>getPlacesMap() async{
    Database db = await this.database;
    var result = await db.query(tableName);
    return result;
  }
  //Insert
  Future<int> insertPlace(Place place) async{
    print(tableName);
    Database db = await this.database;
    var result = await db.insert(tableName, place.toMap());
    return result;
  }
  //Update
  Future<int> updatePlace(Place oldPlace,Place newPlace) async{
    Database db = await this.database;
    var result = await db.update(tableName, newPlace.toMap(),where: '$cId = ? AND $cPlaceName = ?',whereArgs: [oldPlace.id,oldPlace.name]);
    return result;
  }
  //Get individual
  Future<List<Map<String,dynamic>>> getPlaceMap(String name,int id) async{
    Database db = await this.database;
    var result = await db.query(tableName,where: '$cPlaceName = ? AND $cId = ?',whereArgs:[name,id.toString()] );
    return result;
  }
  //Delete
  Future<int> deletePlace(String name,int id) async{
    Database db = await this.database;
    var result = await db.delete(tableName,where: '$cPlaceName = ? AND $cId = ?',whereArgs:[name,id.toString()] );
    return result;
  }
  //Count
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    int count = Sqflite.firstIntValue(x);
    return count;
  }
  Future<List<Place>> getPlaceIndividual(int id,String name) async{
    var placeMapList = await getPlaceMap(name,id);
    int count =  placeMapList.length;
    List<Place> userList = List<Place>();

    for(int i = 0; i < count; i++){
      userList.add(Place.fromMapObject(placeMapList[i]));
    }
    return userList;
  }
  Future<List<Place>> getPlaceList() async{
    var placeMapList = await getPlacesMap();
    int count =  placeMapList.length;
    List<Place> userList = List<Place>();

    for(int i = 0; i < count; i++){
      userList.add(Place.fromMapObject(placeMapList[i]));
    }
    return userList;

  }
  Future<int> deleteAll() async{
    Database db = await this.database;
    var result = await db.delete(tableName);
    return result;
  }
  void getTables() async{
    Database db = await this.database;
    var result = await db.rawQuery("SELECT name FROM sqlite_master WHERE type = 'table' AND name NOT LIKE 'sqlie_%'");
    print(result);
  }
}