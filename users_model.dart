
class User{
  String _firstName,_lastName,_emailAddress,_username,_password;
  User(this._firstName,this._lastName,this._emailAddress,this._username,this._password);

  get firstName => _firstName;
  set firstName(String value) {
    _firstName = value;
  }

  get lastName => _lastName;
  set lastName(value) {
    _lastName = value;
  }

  get emailAddress => _emailAddress;
  set emailAddress(value) {
    _emailAddress = value;
  }

  get username => _username;
  set username(value) {
    _username = value;
  }

  get password => _password;
  set password(value) {
    _password = value;
  }
  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['emailAddress'] = _emailAddress;
    map['username'] = _username;
    map['password'] = _password;
    return map;
  }
  User.fromMapObject(Map<String,dynamic> map){
    this._firstName = map['firstName'];
    this.lastName = map['lastName'];
    this._emailAddress = map['emailAddress'];
    this._username = map['username'];
    this._password = map['password'];
  }
}
