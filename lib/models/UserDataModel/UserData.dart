class UserData
{
  String? id;
  String? name;
  String? lastName;
  //String? birthDate;
  String? email;
  String? role;

  UserData.fromJson(Map<String,dynamic>json)
  {
    id=json['_id'];
    name=json['name'];
    lastName= json['last_name'];
    email=json['email'];
    //birthDate= json['birthDate'];
    role=json['role'];
  }
}