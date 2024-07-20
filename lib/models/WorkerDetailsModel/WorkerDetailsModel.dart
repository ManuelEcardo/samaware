import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class WorkersDetailsModel
{
  List<WorkerWithDetailsModel>? workers=[];

  WorkersDetailsModel.fromJson(Map<String,dynamic> json)
  {
    if(json['workers']!=null)
    {
      for (var worker in json['workers'])
      {
        workers?.add(WorkerWithDetailsModel.fromJson(worker));
      }
    }

  }
}


class WorkerWithDetailsModel
{
  UserData? worker;

  List<OrderModel>? orders=[];

  Pagination? pagination;

  WorkerWithDetailsModel.fromJson(Map<String,dynamic>json)
  {
    worker= UserData.fromJson(json);

    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        orders?.add(OrderModel.fromJson(order, isWorkerPassed: true, worker:worker));
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
        OrderModel myOrder = OrderModel.fromJson(order, isWorkerPassed: true, worker:worker);

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