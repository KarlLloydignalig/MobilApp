

class Place {
  int _id;
  double _rating;
  int _commentCount = 0,_heartCount = 0,_wishCount = 0,_visitorCounter = 0;
  double _fees;
  String _name,_location,_description,_coverPhotoPath,_tag,_comments,_cityName,photoGallery;
  int _isSpot;



  Place(this._name, this._cityName ,this._location, this._description,
      this._isSpot,this._tag,this._fees,this._rating, this._coverPhotoPath,{this.photoGallery = ""});

  String getGallery(){
    return photoGallery;
  }
  void setGallery(String path){
    photoGallery = path;
  }


  get visitedCounter => _visitorCounter;

  set visitedCounter(value) {
    _visitorCounter = value;
  }

  int get isSpot => _isSpot;

  set isSpot(int value) {
    _isSpot = value;
  }

  get cityName => _cityName;

  set cityName(value) {
    _cityName = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  get location => _location;

  set location(value) {
    _location = value;
  }

  get tag => _tag;
  set tag(value) {
    _tag = value;
  }

  get description => _description;

  set description(value) {
    _description = value;
  }

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
  }

  String get coverPhotoPath => _coverPhotoPath;

  set coverPhotoPath(String value) {
    _coverPhotoPath = value;
  }

  get heartCount => _heartCount;

  set heartCount(value) {
    _heartCount = value;
  }

  double get fees => _fees;

  set fees(double value) {
    _fees = value;
  }

  get comments => _comments;

  set comments(value) {
    _comments = value;
  }

  int get commentCount => _commentCount;

  set commentCount(int value) {
    _commentCount = value;
  }

  get wishCount => _wishCount;

  set wishCount(value) {
    _wishCount = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['id'] = _id;
    map['name'] = _name;
    map['location'] = _location;
    map['description'] = _description;
    map['isSpot'] = _isSpot;
    map['rating'] = _rating;
    map['coverPhoto'] = _coverPhotoPath;
    map['tag'] = _tag;
    //added values
    map['commentCount'] = _commentCount;
    map['heartCount'] = _heartCount;
    map['wishCount'] = _wishCount;
    map['comments'] = _comments;
    map['fees'] = _fees;
    map['cityName'] = _cityName;
    //new values
    map['visitorCounter'] = _visitorCounter;

    //new Value
    map['photoGallery'] = photoGallery;

    return map;
  }
  Place.fromMapObject(Map<String,dynamic> map){
    this._id = map['id'];
    this._name = map['name'];
    this._location = map['location'];
    this._description = map['description'];
    this._isSpot = map['isSpot'];//change from specialty to isSpot
    this._rating = map['rating'];
    this._coverPhotoPath = map['coverPhoto'];
    this._tag = map['tag'];
    //added values
    this._commentCount = map['commentCount'];
    this._heartCount = map['heartCount'];
    this._wishCount = map['wishCount'];
    this._comments = map['comments'];
    this._fees = map['fees'];
    this._cityName = map['cityName'];
    this._visitorCounter = map['visitorCounter'];
    this.photoGallery = map['photoGallery'];
  }


}