import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class ScannersDetailsModel
{
  List<ScannerDetailsModel>? scanners=[];

  ScannersDetailsModel.fromJson(Map<String,dynamic> json)
  {
    if(json['scanners'] !=null)
    {
      for(var scanner in json['scanners'])
      {
        scanners?.add(ScannerDetailsModel.fromJson(scanner));
      }
    }
  }
}

class ScannerDetailsModel
{
  UserData? scanner;

  List<OrderModel>? orders=[];

  Pagination? pagination;

  ScannerDetailsModel.fromJson(Map<String,dynamic> json)
  {
    scanner= UserData.fromJson(json);

    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        orders?.add(OrderModel.fromJson(order, isScannerPassed: true, scanner: scanner));
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
        OrderModel myOrder= OrderModel.fromJson(order, isScannerPassed: true, scanner: scanner);

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