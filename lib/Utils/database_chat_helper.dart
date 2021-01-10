import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:paraiso/Models/chat_model.dart';


class DataBaseHelperChat{
  static DataBaseHelperChat _dataBaseHelper;
  static Database _dataBase;
  String tableName = 'chat_table'
  ,cID = 'ID'
  ,cPosterName = 'posterName'
  ,cMessage = 'message'
  ,cDetails = 'details'
  ,cLikeCount = 'likeCount'
  ,cRated = 'rated';

  DataBaseHelperChat._createInstance();
  factory DataBaseHelperChat(){
    if(_dataBaseHelper == null){
      _dataBaseHelper = DataBaseHelperChat._createInstance();
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
    String path = directory.path + 'chat.db';
    var userDatabase = await openDatabase(path,version: 1, onCreate: _createDB);
    return userDatabase;
  }
  Future<int> insertChat(Chat chat) async{
    print(tableName);
    Database db = await this.database;
    var result = await db.insert(tableName, chat.toMap());
    return result;
  }

  void _createDB(Database db, int newVersion) async {
    await db.execute('CREATE TABLE $tableName($cID TEXT,$cDetails TEXT,$cMessage TEXT,$cPosterName TEXT,$cLikeCount INTEGER,$cRated DOUBLE)');

  }
  
  Future<List<Map<String,dynamic>>>getChatMap() async{
    Database db = await this.database;
    var result = await db.query(tableName);
    return result;
  }
  Future<int> updateChat(Chat chat) async{
    Database db = await this.database;
    var result = await db.update(tableName, chat.toMap(),where: ' $cPosterName = ? AND $cID = ?',whereArgs: [chat.iD,chat.posterName]);
    return result;
  }
  Future<List<Map<String,dynamic>>>getChatWhere(String id) async{
    Database db = await this.database;
    var result = await db.rawQuery("SELECT * FROM $tableName WHERE $cID = $id");
    return result;
  }
  
  Future<List<Chat>> getChatList() async{
    var chatMapList = await getChatMap();
    int count =  chatMapList.length;
    List<Chat> chatList = List<Chat>();
    for(int i = 0; i < count; i++){
      chatList.add(Chat.fromMapObject(chatMapList[i]));
    }
    return chatList;
  }

  Future<List<Chat>> getChatListWhere(String _iD) async{
    var chatMapList = await getChatWhere(_iD);
    int count =  chatMapList.length;
    List<Chat> chatList = List<Chat>();
    for(int i = 0; i < count; i++){
      chatList.add(Chat.fromMapObject(chatMapList[i]));
    }
    return chatList;
  }
  Future<int> deleteAll() async{
    Database db = await this.database;
    var result = await db.delete(tableName);
    return result;
  }
}