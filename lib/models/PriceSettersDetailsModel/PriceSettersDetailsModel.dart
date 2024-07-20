import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class PriceSettersDetailsModel
{
  List<PriceSetterDetailsModel>? priceSetters=[];

  PriceSettersDetailsModel.fromJson(Map<String,dynamic> json)
  {
    if(json['priceSetters'] !=null)
    {
      for(var priceSetter in json['priceSetters'])
      {
        priceSetters?.add(PriceSetterDetailsModel.fromJson(priceSetter));
      }
    }
  }
}


class PriceSetterDetailsModel
{
  UserData? priceSetter;

  List<OrderModel>? orders=[];

  Pagination? pagination;

  PriceSetterDetailsModel.fromJson(Map<String,dynamic> json)
  {
    priceSetter= UserData.fromJson(json);

    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        orders?.add(OrderModel.fromJson(order, isPriceSetterPassed: true, priceSetter: priceSetter));
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

        OrderModel myOrder = OrderModel.fromJson(order, isPriceSetterPassed: true, priceSetter: priceSetter);

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