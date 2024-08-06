abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBar extends AppStates{}

class AppAlterBottomNavBarItemsLoadingState extends AppStates{}

class AppAlterBottomNavBarItemsSuccessState extends AppStates{}

class AppAlterBottomNavBarItemsErrorState extends AppStates{}

class AppChangeThemeModeState extends AppStates{}

class AppChangeLanguageState extends AppStates{}


//USER DATA

class AppGetUserDataLoadingState extends AppStates{}

class AppGetUserDataErrorState extends AppStates{}

class AppGetUserDataSuccessState extends AppStates{}

//------------------------------------


//GET WORKERS

class AppGetWorkersLoadingState extends AppStates{}

class AppGetWorkersSuccessState extends AppStates{}

class AppGetWorkersErrorState extends AppStates{}


// Get Excel File and Create Order

class AppExtractExcelFileLoadingState extends AppStates{}

class AppExtractExcelFileSuccessState extends AppStates{}

class AppExtractExcelFileErrorState extends AppStates{}

class AppSetExcelFileState extends AppStates{}

class AppClearOrderState extends AppStates{}

class AppChangeItemQuantityState extends AppStates{}

class AppRemoveItemState extends AppStates{}

class AppSetChosenWorkerState extends AppStates{}

//------------------------------------

//GET NEW CLIENTS FROM EXCEL FILE

class AppSetExcelClientsFileState extends AppStates{}

class AppExtractExcelClientsFileLoadingState extends AppStates{}

class AppExtractExcelClientsFileSuccessState extends AppStates{}

class AppExtractExcelClientsFileErrorState extends AppStates{}

class AppAlterClientState extends AppStates{}

//------------------------------------

// ADD TO PREPARATION TEAM

class AppAddToPreparationTeamState extends AppStates{}

class AppRemoveFromPreparationTeamState extends AppStates{}

//------------------------------------


// CREATE AN ORDER

class AppCreateOrderLoadingState extends AppStates{}

class AppCreateOrderErrorState extends AppStates{}

class AppCreateOrderSuccessState extends AppStates{}

//------------------------------------

// GET NON-READY ORDERS

class AppGetNonReadyOrdersLoadingState extends AppStates{}

class AppGetNonReadyOrdersErrorState extends AppStates{}

class AppGetNonReadyOrdersSuccessState extends AppStates{}

//------------------------------------

// GET ALL ORDERS

class AppGetAllOrdersLoadingState extends AppStates{}

class AppGetAllOrdersErrorState extends AppStates{}

class AppGetAllOrdersSuccessState extends AppStates{}
//------------------------------------

// WS ORDER NOTIFIER

class AppWSOrderUpdateLoadingState extends AppStates{}

class AppWSOrderUpdateSuccessState extends AppStates{}

class AppWSOrderUpdateErrorState extends AppStates{}

//------------------------------------

// LOGOUT

class AppLogoutLoadingState extends AppStates{}
class AppLogoutSuccessState extends AppStates{}
class AppLogoutErrorState extends AppStates{}

//------------------------------------

//WORKER GET WAITING TO BE PREPARED ORDERS

class AppGetWorkerWaitingOrdersLoadingState extends AppStates{}

class AppGetWorkerWaitingOrdersSuccessState extends AppStates{}

class AppGetWorkerWaitingOrdersErrorState extends AppStates{}

//------------------------------------

//PATCH ORDER

class AppPatchOrderLoadingState extends AppStates{}

class AppPatchOrderErrorState extends AppStates{}

class AppPatchOrderSuccessState extends AppStates {}


//------------------------------------

// SET ORDER AS WORKING

class AppSetInWorkingOrderState extends AppStates{}

//------------------------------------

//GET DONE ORDERS BY WORKER

class AppGetWorkerDoneOrdersLoadingState extends AppStates{}

class AppGetWorkerDoneOrdersErrorState extends AppStates{}

class AppGetWorkerDoneOrdersSuccessState extends AppStates{}

//------------------------------------

//GET ALL ORDERS OF A WORKER

class AppGetAllOrdersWorkerLoadingState extends AppStates{}

class AppGetAllOrdersWorkerSuccessState extends AppStates{}

class AppGetAllOrdersWorkerErrorState extends AppStates{}


//------------------------------------

//PRICE SETTER GET WAITING TO BE PREPARED ORDERS

class AppGetPriceSetterWaitingOrdersLoadingState extends AppStates{}

class AppGetPriceSetterWaitingOrdersSuccessState extends AppStates{}

class AppGetPriceSetterWaitingOrdersErrorState extends AppStates{}


//------------------------------------

//GET DONE ORDERS BY A PRICE SETTER

class AppGetPriceSetterDoneOrdersLoadingState extends AppStates{}

class AppGetPriceSetterDoneOrdersErrorState extends AppStates{}

class AppGetPriceSetterDoneOrdersSuccessState extends AppStates{}

//------------------------------------

//GET ALL ORDERS OF A PRICE SETTER

class AppGetAllOrdersPriceSetterLoadingState extends AppStates{}

class AppGetAllOrdersPriceSetterSuccessState extends AppStates{}

class AppGetAllOrdersPriceSetterErrorState extends AppStates{}

//------------------------------------


//INSPECTOR GET WAITING TO BE PREPARED ORDERS

class AppGetInspectorWaitingOrdersLoadingState extends AppStates{}

class AppGetInspectorWaitingOrdersSuccessState extends AppStates{}

class AppGetInspectorWaitingOrdersErrorState extends AppStates{}


//------------------------------------


//GET DONE ORDERS BY AN INSPECTOR

class AppGetInspectorDoneOrdersLoadingState extends AppStates{}

class AppGetInspectorDoneOrdersErrorState extends AppStates{}

class AppGetInspectorDoneOrdersSuccessState extends AppStates{}

//------------------------------------

//GET ALL ORDERS OF AN INSPECTOR

class AppGetAllOrdersInspectorLoadingState extends AppStates{}

class AppGetAllOrdersInspectorSuccessState extends AppStates{}

class AppGetAllOrdersInspectorErrorState extends AppStates{}

//------------------------------------


//COLLECTOR GET WAITING TO BE PREPARED ORDERS

class AppGetCollectorWaitingOrdersLoadingState extends AppStates{}

class AppGetCollectorWaitingOrdersSuccessState extends AppStates{}

class AppGetCollectorWaitingOrdersErrorState extends AppStates{}


//------------------------------------


//GET DONE ORDERS BY AN COLLECTOR

class AppGetCollectorDoneOrdersLoadingState extends AppStates{}

class AppGetCollectorDoneOrdersErrorState extends AppStates{}

class AppGetCollectorDoneOrdersSuccessState extends AppStates{}

//------------------------------------


//GET ALL ORDERS OF AN COLLECTOR

class AppGetAllOrdersCollectorLoadingState extends AppStates{}

class AppGetAllOrdersCollectorSuccessState extends AppStates{}

class AppGetAllOrdersCollectorErrorState extends AppStates{}

//------------------------------------


//SCANNER GET WAITING TO BE PREPARED ORDERS

class AppGetScannerWaitingOrdersLoadingState extends AppStates{}

class AppGetScannerWaitingOrdersSuccessState extends AppStates{}

class AppGetScannerWaitingOrdersErrorState extends AppStates{}


//------------------------------------


//GET DONE ORDERS BY AN SCANNER

class AppGetScannerDoneOrdersLoadingState extends AppStates{}

class AppGetScannerDoneOrdersErrorState extends AppStates{}

class AppGetScannerDoneOrdersSuccessState extends AppStates{}



//------------------------------------


//GET ALL ORDERS OF AN SCANNER

class AppGetAllOrdersScannerLoadingState extends AppStates{}

class AppGetAllOrdersScannerSuccessState extends AppStates{}

class AppGetAllOrdersScannerErrorState extends AppStates{}

//------------------------------------

//GET PRICE SETTERS

class AppGetPriceSettersLoadingState extends AppStates{}

class AppGetPriceSettersSuccessState extends AppStates{}

class AppGetPriceSettersErrorState extends AppStates{}

//------------------------------------

//GET INSPECTORS

class AppGetInspectorsLoadingState extends AppStates{}

class AppGetInspectorsSuccessState extends AppStates{}

class AppGetInspectorsErrorState extends AppStates{}


//------------------------------------

//GET COLLECTORS

class AppGetCollectorsLoadingState extends AppStates{}

class AppGetCollectorsSuccessState extends AppStates{}

class AppGetCollectorsErrorState extends AppStates{}


//------------------------------------

//GET SCANNERS

class AppGetScannersLoadingState extends AppStates{}

class AppGetScannersSuccessState extends AppStates{}

class AppGetScannersErrorState extends AppStates{}
//------------------------------------


//GET PAGINATED ORDERS WORKER - MANAGER ROLE

class AppGetNextWorkerMOrdersLoadingState extends AppStates{}

class AppGetNextWorkerMOrdersSuccessState extends AppStates{}

class AppGetNextWorkerMOrdersErrorState extends AppStates{}

//------------------------------------


//GET PAGINATED ORDERS WORKER - WORKER ROLE

class AppGetNextWorkerWOrdersLoadingState extends AppStates{}

class AppGetNextWorkerWOrdersSuccessState extends AppStates{}

class AppGetNextWorkerWOrdersErrorState extends AppStates{}




//------------------------------------

//GET PAGINATED ORDERS PRICE-SETTER - MANAGER ROLE

class AppGetNextPriceSetterMOrdersLoadingState extends AppStates{}

class AppGetNextPriceSetterMOrdersSuccessState extends AppStates{}

class AppGetNextPriceSetterMOrdersErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS PRICE-SETTER - PRICE SETTER ROLE

class AppGetNextPriceSetterOrdersPLoadingState extends AppStates{}

class AppGetNextPriceSetterOrdersPSuccessState extends AppStates{}

class AppGetNextPriceSetterOrdersPErrorState extends AppStates{}

//------------------------------------

//GET PAGINATED ORDERS INSPECTOR - MANAGER ROLE

class AppGetNextInspectorOrdersMLoadingState extends AppStates{}

class AppGetNextInspectorOrdersMSuccessState extends AppStates{}

class AppGetNextInspectorOrdersMErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS INSPECTOR - INSPECTOR  ROLE

class AppGetNextInspectorOrdersILoadingState extends AppStates{}

class AppGetNextInspectorOrdersISuccessState extends AppStates{}

class AppGetNextInspectorOrdersIErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS COLLECTOR - MANAGER ROLE

class AppGetNextCollectorOrdersMLoadingState extends AppStates{}

class AppGetNextCollectorOrdersMSuccessState extends AppStates{}

class AppGetNextCollectorOrdersMErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS COLLECTOR - COLLECTOR  ROLE

class AppGetNextCollectorOrdersCLoadingState extends AppStates{}

class AppGetNextCollectorOrdersCSuccessState extends AppStates{}

class AppGetNextCollectorOrdersCErrorState extends AppStates{}


//------------------------------------




//GET PAGINATED ORDERS SCANNER - MANAGER ROLE

class AppGetNextScannerOrdersMLoadingState extends AppStates{}

class AppGetNextScannerOrdersMSuccessState extends AppStates{}

class AppGetNextScannerOrdersMErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS SCANNER - SCANNER  ROLE

class AppGetNextScannerOrdersSLoadingState extends AppStates{}

class AppGetNextScannerOrdersSSuccessState extends AppStates{}

class AppGetNextScannerOrdersSErrorState extends AppStates{}


//------------------------------------

//GET PAGINATED ORDERS

class AppGetNextOrdersLoadingState extends AppStates{}

class AppGetNextOrdersSuccessState extends AppStates{}

class AppGetNextOrdersErrorState extends AppStates{}

//------------------------------------

// TO DATABASE

class AppAddDatabaseLoadingState extends AppStates{}

class AppAddDatabaseSuccessState extends AppStates{}

class AppAddDatabaseErrorState extends AppStates{}

//------------------------------------

// SEARCH ORDER

class AppSearchOrdersLoadingState extends AppStates{}

class AppSearchOrdersErrorState extends AppStates{}

class AppSearchOrdersSuccessState extends AppStates{}

//------------------------------------

//GET SALESMAN: MANAGER

class AppGetSalesmenLoadingState extends AppStates{}

class AppGetSalesmenSuccessState extends AppStates{}

class AppGetSalesmenErrorState extends AppStates{}

//------------------------------------



