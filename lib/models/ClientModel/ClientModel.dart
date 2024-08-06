import 'package:samaware_flutter/models/SalesmenModel/SalesmenModel.dart';

class ClientModel
{
  String? id;
  String? clientId;
  String? name;
  String? details;
  String? location;
  String? storeName;
  SalesmanModel? salesman;

  ClientModel.fromJson(Map<String,dynamic>json)
  {
    id=json['_id'];
    clientId=json['clientId'];
    name=json['name'];

    details=json['details'];
    location=json['location'];
    storeName=json['storeName'];
    
    salesman=SalesmanModel.fromJson(json['salesmanId']);
  }
}