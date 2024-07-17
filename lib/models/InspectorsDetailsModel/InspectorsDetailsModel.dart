import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class InspectorsDetailsModel
{
  List<InspectorDetailsModel>? inspectors=[];

  InspectorsDetailsModel.fromJson(List<dynamic> json)
  {
    for(var inspector in json)
    {
      inspectors?.add(InspectorDetailsModel.fromJson(inspector));
    }
  }
}

class InspectorDetailsModel
{
  UserData? inspector;

  List<OrderModel>? orders=[];

  InspectorDetailsModel.fromJson(Map<String,dynamic> json)
  {
    inspector= UserData.fromJson(json);

    json['orders'].forEach((order)
    {
      orders?.add(OrderModel.fromJson(order, isInspectorPassed: true, inspector: inspector));
    });
  }
}