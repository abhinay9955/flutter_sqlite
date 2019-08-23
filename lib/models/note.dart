class Note{

  int _id;
  String _name;
  String _description;
  String _email;

  Note(this._name,this._email,[this._description]);
  Note.withId(this._id,this._name,this._email,[this._description]);

  String get email => _email;

  set email(String value) {
    _email = value;
  }

  String get description => _description;

  set description(String value) {
    if(value.length<=255)
     { _description = value;}
  }

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;


Map<String,dynamic> toMap()
{
  Map<String,dynamic> map=Map<String,dynamic>();
  if(_id!=null)
   map["id"]=this._id;
  map["name"]=_name;
  map["email"]=_email;
  map["desc"]=_description;

  return map;
}

 Note.toNote(Map<String,dynamic> map)
{
  _id=map["id"];
  _description=map["desc"];
  _name=map["name"];
  _email=map["email"];
}

}