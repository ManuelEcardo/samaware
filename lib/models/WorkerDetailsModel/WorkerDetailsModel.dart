import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class WorkersDetailsModel
{
  List<WorkerWithDetailsModel>? workers=[];

  WorkersDetailsModel.fromJson(List<dynamic> json)
  {
    for (var worker in json)
    {
      workers?.add(WorkerWithDetailsModel.fromJson(worker));
    }
  }
}


class WorkerWithDetailsModel
{
  UserData? worker;

  List<OrderModel>? orders=[];

  WorkerWithDetailsModel.fromJson(Map<String,dynamic>json)
  {
    worker= UserData.fromJson(json);

    json['orders'].forEach((order)
    {
      orders?.add(OrderModel.fromJson(order, isWorkerPassed: true, worker:worker));
    });

  }

}