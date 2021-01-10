
class Chat {
  String _iD,_posterName,_message,_detail;
  int _likeCount;
  double _rated;


  Chat(this._iD, this._posterName, this._message, this._detail,this._rated);

  get likeCount => _likeCount;

  set likeCount(value) {
    _likeCount = value;
  }

  double get rated => _rated;

  set rated(double value) {
    _rated = value;
  }

  get detail => _detail;

  set detail(value) {
    _detail = value;
  }

  get message => _message;

  set message(value) {
    _message = value;
  }

  get posterName => _posterName;

  set posterName(value) {
    _posterName = value;
  }

  String get iD => _iD;

  set iD(String value) {
    _iD = value;
  }

  Map<String,dynamic> toMap(){
    var map = Map<String,dynamic>();
    map['ID'] = _iD;
    map['posterName'] = _posterName;
    map['message'] = _message;
    map['details'] = _detail;
    //new
    map['likeCount'] = _likeCount;
    map['rated'] = _rated;
    return map;
  }
  Chat.fromMapObject(Map<String,dynamic> map){
    this._iD =  map['ID'];
    this._posterName = map['posterName'];
    this._message = map['message'];
    this._detail =  map['details'];

    //new
    this._likeCount = map['likeCount'];
    this._rated =  map['rated'];

  }
}