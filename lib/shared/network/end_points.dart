import 'package:flutter/foundation.dart' show kIsWeb;

//LOCAL HOST

String localhost= kIsWeb? 'http://localhost:3000/' : 'http://10.0.2.2:3000/';
const String webSocketLocalHost= kIsWeb? 'ws://localhost:3000/webSocket' : 'ws://10.0.2.2:3000/webSocket';


//LOCAL NETWORK

// String localhost= 'http://192.168.1.14:3000/';
// String webSocketLocalHost = 'ws://192.168.1.14:3000/webSocket';

//NGROK

//String localhost= 'https://conversely-inviting-gelding.ngrok-free.app/';
//String webSocketLocalHost = 'ws://conversely-inviting-gelding.ngrok-free.app/webSocket';


//USER ENDPOINTS

const login='users/login';

const userDataByToken='users/me';

const workersForManager='workers/';

const workersWithDetail='workers/details';

const priceSettersWithDetail='priceSetters/details';

const inspectorWithDetail='inspectors/details';

const logoutOneToken='users/logout';


//WORKER ENDPOINTS

const getAwaitingOrders= 'orders/waiting_me';

//Price SETTER ENDPOINTS

const getAwaitingOrdersPriceSetters= 'orders/priceSetter/waiting_me';

const getAwaitingOrdersInspector='orders/inspector/waiting_me';


//ORDER ENDPOINTS

const createAnOrder= 'orders/create';

const notReadyOrders='orders/nonReady';

const AllOrders='orders';

const patchAnOrder='orders/patch';

const doneOrdersByUser='orders/doneMe';

const allOrdersWorker='orders/me';
