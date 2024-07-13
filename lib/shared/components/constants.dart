//User Token
import 'package:intl/intl.dart';

String token='';

//Is Active in app => allows re connection to WebSockets
bool isActive=true;


List<String> allowedFiles=['xlsx', 'xls'];


///A default formatter for dd/MM/yyyy HH:mm:ss
DateFormat defaultDateFormatter = DateFormat('dd/MM/yyyy HH:mm:ss');