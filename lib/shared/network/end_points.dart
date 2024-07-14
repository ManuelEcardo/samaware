import 'package:flutter/foundation.dart' show kIsWeb;

String localhost= kIsWeb? 'http://localhost:3000/' : 'http://10.0.2.2:3000/';

const String webSocketLocalHost= kIsWeb? 'ws://localhost:3000/webSocket' : 'ws://10.0.2.2:3000/webSocket';  // ws://192.168.1.1:3000/webSocket



//USER ENDPOINTS

const login='users/login';

const userDataByToken='users/me';

const workersForManager='workers/';

const workersWithDetail='workers/details';


//ORDER ENDPOINTS

const createAnOrder= 'orders/create';

const notReadyOrders='orders/nonReady';
