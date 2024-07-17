import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class PriceSettersDetailsModel
{
  List<PriceSetterDetailsModel>? priceSetters=[];

  PriceSettersDetailsModel.fromJson(List<dynamic> json)
  {
    for(var priceSetter in json)
    {
      priceSetters?.add(PriceSetterDetailsModel.fromJson(priceSetter));
    }
  }
}


class PriceSetterDetailsModel
{
  UserData? priceSetter;

  List<OrderModel>? orders=[];

  PriceSetterDetailsModel.fromJson(Map<String,dynamic> json)
  {
    priceSetter= UserData.fromJson(json);

    json['orders'].forEach((order)
    {
      orders?.add(OrderModel.fromJson(order, isPriceSetterPassed: true, priceSetter: priceSetter));
    });
  }
}