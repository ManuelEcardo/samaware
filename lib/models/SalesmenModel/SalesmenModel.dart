class SalesmenModel
{
  List<SalesmanModel?>? salesmen=[];

  SalesmenModel.fromJson(List<dynamic>json)
  {
    for(var salesman in json)
    {
      salesmen?.add(SalesmanModel.fromJson(salesman));
    }
  }
}


class SalesmanModel
{
  String? id;
  String? name;
  String? salesmanId;
  String? createdAt;
  String? updatedAt;


  SalesmanModel.fromJson(Map<String,dynamic>json)
  {
    id=json['_id'];
    name=json['name'];
    salesmanId=json['salesmanId'];
    createdAt=json['createdAt'];
    updatedAt=json['updatedAt'];
  }
}