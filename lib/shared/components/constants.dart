//User Token
import 'dart:ui';

import 'package:intl/intl.dart';

//Token to be cached
String token='';

//Is Active in app => allows re connection to WebSockets
bool isActive=true;

//Allowed excel files
List<String> allowedFiles=['xlsx', 'xls'];


///A default formatter for dd/MM/yyyy HH:mm:ss
DateFormat defaultDateFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');

//Setting devices types
Set<PointerDeviceKind> dragDevices={PointerDeviceKind.touch, PointerDeviceKind.mouse, PointerDeviceKind.trackpad};


const String manager='manager';

const String worker= 'worker';

const String inspector= 'inspector';

const String priceSetter= 'priceSetter';


///Order State types as enums
enum OrderState
{
  waiting_to_be_prepared, being_prepared, prepared, being_priced, priced,
  being_verified,verified,re_prepare,waiting_to_ship,stored,shipped,failed
}

///Order Date types as enums
enum OrderDate
{
  waiting_to_be_prepared_date, being_prepared_date, prepared_date, being_priced_date,
  priced_date, being_verified_date, verified_date, waiting_to_ship_date, stored_date,
  shipped_date, failed_date, re_prepare_date

}

///Worker Order Failure Reasons
List<String> workerOrderFailureReasons=['no_available_items_failure','other_reason_failure'];

///Inspector Order Failure Reasons
List<String> inspectorOrderFailureReasons=['wrong_items_failure','other_reason_failure'];