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
    role=json['role'];
  }

  @override
  String toString()
  {
    return "ID:$id, Name:$name, Last name: $lastName, email:$email, role;$role";
  }
}