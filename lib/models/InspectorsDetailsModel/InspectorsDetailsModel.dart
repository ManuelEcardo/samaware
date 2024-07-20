import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class InspectorsDetailsModel
{
  List<InspectorDetailsModel>? inspectors=[];

  InspectorsDetailsModel.fromJson(Map<String,dynamic> json)
  {
    if(json['inspectors'] !=null)
    {
      for(var inspector in json['inspectors'])
      {
        inspectors?.add(InspectorDetailsModel.fromJson(inspector));
      }
    }
  }
}

class InspectorDetailsModel
{
  UserData? inspector;

  List<OrderModel>? orders=[];

  Pagination? pagination;

  InspectorDetailsModel.fromJson(Map<String,dynamic> json)
  {
    inspector= UserData.fromJson(json);

    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        orders?.add(OrderModel.fromJson(order, isInspectorPassed: true, inspector: inspector));
      });
    }
  }

  /// Adds orders to object
  void addOrders(Map<String,dynamic> json)
  {
    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        OrderModel myOrder= OrderModel.fromJson(order, isInspectorPassed: true, inspector: inspector);

        if(isFound(myOrder.orderId) == false)
        {
          orders?.add(myOrder);
        }
      });
    }
  }

  /// Adds pagination
  void addPagination(Map<String,dynamic> json)
  {
    if(json['pagination'] !=null)
    {
      pagination = Pagination.fromJson(json['pagination']);
    }
  }

  ///Checks if order exists
  bool isFound(String? id)
  {
    for(OrderModel order in orders?? [])
    {
      if(order.orderId == id)
      {
        return true;
      }
    }

    return false;
  }

}