import 'package:flutter/foundation.dart' show kIsWeb;

//LOCAL HOST

String localhost= kIsWeb? 'http://localhost:3000/' : 'https://10.0.2.2:4443/'; //kIsWeb? 'http://localhost:3000/' : 'http://10.0.2.2:3000/';
String webSocketLocalHost= kIsWeb? 'ws://localhost:3000/webSocket' : 'ws://10.0.2.2:3000/webSocket';


//LOCAL NETWORK

// String localhost= 'http://192.168.1.14:3000/';
// String webSocketLocalHost = 'ws://192.168.1.14:3000/webSocket';

//NGROK

//String localhost= 'https://conversely-inviting-gelding.ngrok-free.app/';
//String webSocketLocalHost = 'ws://conversely-inviting-gelding.ngrok-free.app/webSocket';


//Render.com

// String localhost='https://samaware-backend.onrender.com/';
// String webSocketLocalHost= 'ws://samaware-backend.onrender.com/webSocket';

//USER ENDPOINTS

const login='users/login';

const userDataByToken='users/me';

const logoutOneToken='users/logout';


//WORKER ENDPOINTS

const getAwaitingOrders= 'orders/workerRole/waiting_me';

const workersForManager='workers/all';

const workersWithDetail='workers/details';



//PRICE-SETTER ENDPOINTS

const getAwaitingOrdersPriceSetters= 'orders/priceSetter/waiting_me';

const getAwaitingOrdersInspector='orders/inspector/waiting_me';

const priceSettersWithDetail='priceSetters/details';

const allPriceSetters='priceSetters/all';

//INSPECTOR ENDPOINTS

const inspectorWithDetail='inspectors/details';

const allInspectors='inspectors/all';


//COLLECTOR ENDPOINTS

const getAwaitingOrdersCollector = 'orders/collector/waiting_me';

const allCollectors='collectors/all';


//SCANNER ENDPOINTS

const getAwaitingOrdersScanner = 'orders/scanner/waiting_me';

const allScanners='scanners/all';

//ORDER ENDPOINTS

const createAnOrder= 'orders/create';

const notReadyOrders='orders/nonReady';

const AllOrders='orders';

const patchAnOrder='orders/patch';

const doneOrdersByUser='orders/doneMe';

const allOrdersUsers='orders/me';

const searchFOrders='orders/search';

//ORDER WORKER

const workerOrders='orders/worker';

//ORDER PRICE-SETTER

const priceSetterOrders='orders/priceSetter';

//ORDER INSPECTOR

const inspectorOrders='orders/inspector';

//ORDER COLLECTOR

const collectorOrders='orders/collector';

//ORDER SCANNER

const scannerOrders='orders/scanner';