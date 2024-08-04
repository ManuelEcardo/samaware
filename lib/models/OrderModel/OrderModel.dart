import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class OrdersModel
{
  List<OrderModel>? orders=[];
  Pagination? pagination;

  OrdersModel.fromJson(Map<String,dynamic> json)
  {
    json['orders'].forEach((element)
    {
      orders?.add(OrderModel.fromJson(element));
    });

    if(json['pagination'] !=null)
    {
      pagination = Pagination.fromJson(json['pagination']);
    }
  }


  /// Adds orders to object
  void addOrders(Map<String,dynamic> json)
  {
    if(json['orders'] !=null)
    {
      json['orders'].forEach((order)
      {
        OrderModel myOrder = OrderModel.fromJson(order);

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

  @override
  String toString() {
    return orders.toString();
  }
}

class OrderModel
{
  String? objectId;

  String? orderId;
  UserData? worker;
  String? clientId;
  List<String>? preparationTeam=[];

  UserData? priceSetter;
  UserData? inspector;
  UserData? collector;
  UserData? scanner;

  String? registrationDate;
  String? shippingDate;

  String? waitingToBePreparedDate; //waiting_to_be_prepared_date;
  String? beingPreparedDate;
  String? preparedDate;

  String? beingPricedDate;
  String? pricedDate;

  String? beingCollectedDate;
  String? collectedDate;

  String? beingScannedDate;
  String? scannedDate;

  String? beingVerifiedDate;
  String? verifiedDate;

  String? waitingToShipDate;

  String? storedDate;
  String? shippedDate;

  String? failedDate;
  String? rePrepareDate;


  String? status;
  List<OrderItem>? items=[];
  String? failureReason;

  //IsWorkerPassed and w are written for when we return the api /workers/details => we won't send in each order the worker details again, so we pass it literally since we have it.
  OrderModel.fromJson(
      Map<String,dynamic>json,
      {bool isWorkerPassed=false, UserData? worker, bool isPriceSetterPassed=false, UserData? priceSetter,
        bool isInspectorPassed=false, UserData? inspector,
        bool isCollectorPassed=false, UserData? collector,
        bool isScannerPassed=false, UserData? scanner,
      })
  {
    objectId= json['order']['_id'];

    orderId=json['order']['orderId'];

    this.worker= isWorkerPassed? worker : UserData.fromJson(json['order']['workerId']);

    if(json['order']['priceSetterId'] !=null) this.priceSetter= isPriceSetterPassed? priceSetter : UserData.fromJson(json['order']['priceSetterId']);

    if(json['order']['inspectorId']!=null) this.inspector= isInspectorPassed? inspector : UserData.fromJson(json['order']['inspectorId']);

    if(json['order']['collectorId']!=null) this.collector = isCollectorPassed? collector : UserData.fromJson(json['order']['collectorId']);

    if(json['order']['scannerId']!=null) this.scanner = isScannerPassed? scanner : UserData.fromJson(json['order']['scannerId']);

    clientId=json['order']['clientId'];

    status=json['order']['status'];

    json['items'].forEach((item)
    {
      items?.add(OrderItem.fromJson(item));
    });


    if(json['order']['preparationTeam'] !=null)
    {
      json['order']['preparationTeam'].forEach((member)
      {
        preparationTeam?.add(member['name']);
      });
    }

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

    if(json['order']['being_collected_date'] !=null)
    {
      beingCollectedDate = json['order']['being_collected_date'];
    }

    if(json['order']['collected_date'] !=null)
    {
      collectedDate=json['order']['collected_date'];
    }

    if(json['order']['being_scanned_date'] !=null)
    {
      beingScannedDate = json['order']['being_scanned_date'];
    }

    if(json['order']['scanned_date'] !=null)
    {
      scannedDate=json['order']['scanned_date'];
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
      shippedDate=json['order']['shipped_date'];
    }

    if(json['order']['failed_date']!=null)
    {
      failedDate=json['order']['failed_date'];
    }

    if(json['order']['re_prepare_date']!=null)
    {
      rePrepareDate=json['order']['re_prepare_date'];
    }

    if(json['order']['failure_reason'] !=null)
    {
      failureReason = json['order']['failure_reason'];
    }

  }


  @override
  String toString() {
    return '''
OrderModel {
  objectId: $objectId,
  orderId: $orderId,
  worker: ${worker.toString()},
  clientId: $clientId,
  preparationTeam: ${preparationTeam?.join(', ')},
  priceSetter: ${priceSetter.toString()},
  inspector: ${inspector.toString()},
  collector: ${collector.toString()},
  scanner: ${scanner.toString()},
  registrationDate: $registrationDate,
  shippingDate: $shippingDate,
  waitingToBePreparedDate: $waitingToBePreparedDate,
  beingPreparedDate: $beingPreparedDate,
  preparedDate: $preparedDate,
  beingPricedDate: $beingPricedDate,
  pricedDate: $pricedDate,
  beingCollectedDate: $beingCollectedDate,
  collectedDate: $collectedDate,
  beingScannedDate: $beingScannedDate,
  scannedDate: $scannedDate,
  beingVerifiedDate: $beingVerifiedDate,
  verifiedDate: $verifiedDate,
  waitingToShipDate: $waitingToShipDate,
  storedDate: $storedDate,
  shippedDate: $shippedDate,
  failedDate: $failedDate,
  rePrepareDate: $rePrepareDate,
  status: $status,
  items: ${items?.map((e) => e.toString()).join(', ')},
  failureReason: $failureReason,
}
    ''';
  }
}


class Pagination
{
  int? currentPage;
  int? totalPages;

  String? nextPage;
  String? previousPage;

  Pagination.fromJson(Map<String,dynamic> json)
  {
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];

    if(json['nextPage'] !=null)
    {
      nextPage = json['nextPage'];
    }

    if(json['prevPage']!=null)
    {
      previousPage = json['prevPage'];
    }
  }
}