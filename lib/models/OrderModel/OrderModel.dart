import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class OrdersModel
{
  List<OrderModel>? orders=[];

  OrdersModel.fromJson(List<dynamic> json)
  {
    for(Map<String,dynamic> element in json)
    {
      orders?.add(OrderModel.fromJson(element));
    }
  }
}

class OrderModel
{
  String? objectId;

  String? orderId;
  UserData? worker;
  String? clientId;

  UserData? priceSetter;
  UserData? inspector;

  String? registrationDate;
  String? shippingDate;
  String? waitingToBePreparedDate; //waiting_to_be_prepared_date;
  String? beingPreparedDate;
  String? preparedDate;
  String? beingPricedDate;
  String? pricedDate;
  String? beingVerifiedDate;
  String? verifiedDate;
  String? waitingToShipDate;
  String? storedDate;
  String? shippedDate;
  String? failedDate;
  String? rePrepareDate;


  String? status;
  List<OrderItem>? items=[];

  //IsWorkerPassed and w are written for when we return the api /workers/details => we won't send in each order the worker details again, so we pass it literally since we have it.
  OrderModel.fromJson(Map<String,dynamic>json, {bool isWorkerPassed=false, UserData? worker, bool isPriceSetterPassed=false, UserData? priceSetter, bool isInspectorPassed=false, UserData? inspector})
  {
    objectId= json['order']['_id'];

    orderId=json['order']['orderId'];

    this.worker= isWorkerPassed? worker : UserData.fromJson(json['order']['workerId']);

    if(json['order']['priceSetterId'] !=null) this.priceSetter= isPriceSetterPassed? priceSetter : UserData.fromJson(json['order']['priceSetterId']);

    if(json['order']['inspectorId']!=null) this.inspector= isInspectorPassed? inspector : UserData.fromJson(json['order']['inspectorId']);

    clientId=json['order']['clientId'];

    status=json['order']['status'];

    json['items'].forEach((item)
    {
      items?.add(OrderItem.fromJson(item));
    });

    if(json['order']['registration_date']!=null)
    {
      registrationDate=json['order']['registration_date'];
    }

    if(json['order']['shipping_date']!=null)
    {
      shippingDate=json['order']['shipping_date'];
    }

    if(json['order']['waiting_to_be_prepared_date']!=null)
    {
      waitingToBePreparedDate=json['order']['waiting_to_be_prepared_date'];
    }

    if(json['order']['being_prepared_date']!=null)
    {
      beingPreparedDate=json['order']['being_prepared_date'];
    }

    if(json['order']['prepared_date']!=null)
    {
      preparedDate=json['order']['prepared_date'];
    }

    if(json['order']['being_priced_date']!=null)
    {
      beingPricedDate=json['order']['being_priced_date'];
    }

    if(json['order']['priced_date']!=null)
    {
      pricedDate=json['order']['priced_date'];
    }

    if(json['order']['being_verified_date']!=null)
    {
      beingVerifiedDate=json['order']['being_verified_date'];
    }

    if(json['order']['verified_date']!=null)
    {
      verifiedDate=json['order']['verified_date'];
    }

    if(json['order']['waiting_to_ship_date']!=null)
    {
      waitingToShipDate=json['order']['waiting_to_ship_date'];
    }

    if(json['order']['stored_date']!=null)
    {
      storedDate=json['order']['stored_date'];
    }

    if(json['order']['shipped_date']!=null)
    {
      shippingDate=json['order']['shipped_date'];
    }

    if(json['order']['failed_date']!=null)
    {
      failedDate=json['order']['failed_date'];
    }

    if(json['order']['re_prepare_date']!=null)
    {
      rePrepareDate=json['order']['re_prepare_date'];
    }

  }


}