
class User{
  String _firstName,_lastName,_emailAddress,_username,_password,_visitedPlace,_wishPlace,_heartPlace,_commentedPlace,_log,_profilePicFilePath,_address,_currentLocation;



  User(this._firstName,this._lastName,this._address,this._emailAddress,this._username,this._password);

  get commentedPlace => _commentedPlace;

  set commentedPlace(value) {
    _commentedPlace = value;
  }

  get heartPlace => _heartPlace;

  set heartPlace(value) {
    _heartPlace = value;
  }

  get currentLocation => _currentLocation;

  set currentLocation(value) {
    _currentLocation = value;
  }
  get address => _address;

  set address(value) {
    _address = value;
  }

  get profilePicFilePath => _profilePicFilePath;

  set profilePicFilePath(value) {
    _profilePicFilePath = value;
  }

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

  get wishPlace => _wishPlace;

  set wishPlace(value) {
    _wishPlace = value;
  }

  get log => _log;

  set log(value) {
    _log = value;
  }

  get visitedPlace => _visitedPlace;

  set visitedPlace(value) {
    _visitedPlace = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['firstName'] = _firstName;
    map['lastName'] = _lastName;
    map['emailAddress'] = _emailAddress;
    map['username'] = _username;
    map['password'] = _password;
    map['visitedPlace'] = _visitedPlace;
    map['wishPlace'] = _wishPlace;
    map['log'] = _log;
    map['profilePicFilePath'] = _profilePicFilePath;

    map['currentLocation'] = _currentLocation;
    map['address'] = _address;
    map['heartPlace'] = _heartPlace;
    map['commentedPlace'] = _commentedPlace;

    return map;
  }
  User.fromMapObject(Map<String,dynamic> map){
    this._firstName = map['firstName'];
    this.lastName = map['lastName'];
    this._emailAddress = map['emailAddress'];
    this._username = map['username'];
    this._password = map['password'];
    //added vales
    this._visitedPlace = map['visitedPlace'];
    this._wishPlace = map['wishPlace'];
    this._log = map['log'];
    this._profilePicFilePath = map['profilePicFilePath'];

    this._currentLocation = map['currentLocation'];
    this._address = map['address'];

    this._heartPlace = map['heartPlace'];
    this._commentedPlace = map['commentedPlace'];
  }


}
