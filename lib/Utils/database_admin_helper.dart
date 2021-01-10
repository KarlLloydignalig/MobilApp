import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:paraiso/Models/admin_model.dart';

class DataBaseHelperAdmin{
  static DataBaseHelperAdmin _dataBaseHelper;
  static Database _dataBase;
  String tableName = 'admin_table'
  ,cUsername = 'username'
  ,cPassword = 'password';

  DataBaseHelperAdmin._createInstance();
  factory DataBaseHelperAdmin(){
    if(_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelperAdmin._createInstance();
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
    String path = directory.path + 'admin.db';
    var userDatabase = await openDatabase(path,version: 1, onCreate: _createDB);
    return userDatabase;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($cUsername TEXT,$cPassword TEXT)');
    var result = await db.insert(tableName, new Admin('karl123','1').toMap());
  }
  Future<List<Map<String,dynamic>>>getAdminMap() async{
    Database db = await this.database;
    var result = await db.query(tableName);
    return result;
  }
  Future<int> updateAdmin(Admin adminOld,Admin adminNew) async{
    Database db = await this.database;
    var result = await db.update(tableName, adminNew.toMap(),where: ' $cPassword = ? AND $cUsername = ?',whereArgs: [adminOld.password,adminOld.username]);
    return result;
  }
  Future<List<Admin>> getAdminList() async{
    var placeMapList = await getAdminMap();
    int count =  placeMapList.length;
    List<Admin> userList = List<Admin>();

    for(int i = 0; i < count; i++){
      userList.add(Admin.fromMapObject(placeMapList[i]));
    }
    return userList;

  }
}