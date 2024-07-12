import 'package:samaware_flutter/models/UserDataModel/UserData.dart';

class WorkerModel
{
  List<UserData>? workers=[];

  WorkerModel.fromJson(Map<String,dynamic>json)
  {
    json['workers'].forEach((worker)
    {
      workers?.add(UserData.fromJson(worker));
    });
  }
}