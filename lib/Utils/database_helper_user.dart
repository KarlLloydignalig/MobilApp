import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:paraiso/Models/users_model.dart';


class DataBaseHelperUser{
  static DataBaseHelperUser _dataBaseHelper;
  static Database _dataBase;
  String tableName = 'users_table'
  ,cFirstName = 'firstName'
  ,cLastName = 'lastName'
  ,cEmailAddress = 'emailAddress'
  ,cUsername = 'username'
  ,cPassword = 'password'
  ,cVisitedPlace = 'visitedPlace'
  ,cWishPlace = 'wishPlace'
  ,cLog = 'log'
  ,cProfilePicFilePath = 'profilePicFilePath'
  ,cAddress = 'address'
  ,cCurrentLocation = 'currentLocation'
  ,cHeartPlace = 'heartPlace'
  ,cCommentedPlace = 'commentedPlace';
  DataBaseHelperUser._createInstance();

  factory DataBaseHelperUser(){
    if(_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelperUser._createInstance();
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
    String path = directory.path + 'user.db';
    var userDatabase = await openDatabase(path,version: 1, onCreate: _createDB);
    return userDatabase;
  }
  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($cFirstName TEXT,$cLastName TEXT,'
        '$cAddress TEXT,$cCurrentLocation TEXT,'
        '$cEmailAddress TEXT,$cUsername TEXT,$cPassword TEXT,'
        '$cWishPlace TEXT,$cVisitedPlace TEXT,$cHeartPlace TEXT,$cCommentedPlace TEXT, $cLog TEXT,$cProfilePicFilePath TEXT)');
  }


  //Fetch
  Future<List<Map<String,dynamic>>>getUsersMap() async{
    Database db = await this.database;
    var result = await db.query(tableName);
    return result;
  }
  //Insert
  Future<int> insertUser(User user) async{
    Database db = await this.database;
    var result = await db.insert(tableName, user.toMap());
    return result;
  }
  //Update
  Future<int> updateUser(User user) async{
    Database db = await this.database;
    var result = await db.update(tableName, user.toMap(),where: '$cUsername = ? AND $cPassword = ?',whereArgs: [user.username,user.password]);
    return result;
  }
  Future<int> updateUserWithPasswordUsername(User user,String username,String password) async{
    Database db = await this.database;
    var result = await db.update(tableName, user.toMap(),where: '$cUsername = ? AND $cPassword = ?',whereArgs: [username,password]);
    return result;
  }
  //Get individual
  Future<List<Map<String,dynamic>>> getUserMap(String username,String password) async{
    Database db = await this.database;
    var result = await db.query(tableName,where: '$cUsername = ? AND $cPassword = ?',whereArgs:[username,password] );
    return result;
  }
  //Delete
  Future<int> deleteUser(String username,String password) async{
    Database db = await this.database;
    var result = await db.delete(tableName,where: '$cUsername = ? AND $cPassword = ?',whereArgs:[username,password] );
    return result;
  }
  //Count
  Future<int> getCount() async{
    Database db = await this.database;
    List<Map<String,dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $tableName');
    int count = Sqflite.firstIntValue(x);
    return count;
  }

  Future<List<User>> getUsersList() async{
    var userMapList = await getUsersMap();
    int count =  userMapList.length;
    List<User> userList = List<User>();

    for(int i = 0; i < count; i++){
      userList.add(User.fromMapObject(userMapList[i]));
    }
    return userList;

  }
  Future<List<User>> getUser(String username,String password) async{
    var userMapList = await getUserMap(username,password);
    int count =  userMapList.length;
    List<User> userList = List<User>();

    for(int i = 0; i < count; i++){
      userList.add(User.fromMapObject(userMapList[i]));
    }
    return userList;

  }
  Future<int> deleteAll() async{
    Database db = await this.database;
    var result = await db.delete(tableName);
    return result;
  }


}