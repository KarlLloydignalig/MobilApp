

class Admin{
  String _username,_password;


  Admin(this._username, this._password);

  String get username => _username;

  set username(String value) {
    _username = value;
  }

  get password => _password;

  set password(value) {
    _password = value;
  }
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }
  Admin.fromMapObject(Map<String,dynamic> map){
    this._username = map['username'];
    this._password = map['password'];

  }
}