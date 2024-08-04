import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class CollectorsDetailsModel
{
  List<CollectorDetailsModel>? collectors=[];

  CollectorsDetailsModel.fromJson(Map<String,dynamic> json)
  {
    if(json['collectors'] !=null)
    {
      for(var collector in json['collectors'])
      {
        collectors?.add(CollectorDetailsModel.fromJson(collector));
      }
    }
  }
}



class CollectorDetailsModel
{
  UserData? collector;

  List<OrderModel>? orders=[];

  Pagination? pagination;

  CollectorDetailsModel.fromJson(Map<String,dynamic> json)
  {
    collector= UserData.fromJson(json);

    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        orders?.add(OrderModel.fromJson(order, isCollectorPassed: true, collector: collector));
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
        OrderModel myOrder= OrderModel.fromJson(order, isCollectorPassed: true, collector: collector);

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