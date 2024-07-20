
abstract class AppStates{}

class AppInitialState extends AppStates{}

class AppChangeBottomNavBar extends AppStates{}

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

// GET WORKERS WITH DETAILS

class AppGetWorkersDetailsLoadingState extends AppStates{}

class AppGetWorkersDetailsSuccessState extends AppStates{}

class AppGetWorkersDetailsErrorState extends AppStates{}

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

// GET PRICE SETTERS DATA

class AppGetPriceSettersDetailsLoadingState extends AppStates{}

class AppGetPriceSettersDetailsErrorState extends AppStates{}

class AppGetPriceSettersDetailsSuccessState extends AppStates{}

//------------------------------------

// GET INSPECTOR DATA

class AppGetInspectorsDetailsLoadingState extends AppStates{}

class AppGetInspectorsDetailsErrorState extends AppStates{}

class AppGetInspectorsDetailsSuccessState extends AppStates{}

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


//GET PAGINATED ORDERS WORKER

class AppGetNextWorkerOrdersLoadingState extends AppStates{}

class AppGetNextWorkerOrdersSuccessState extends AppStates{}

class AppGetNextWorkerOrdersErrorState extends AppStates{}

//------------------------------------

//GET PAGINATED ORDERS PRICE-SETTER

class AppGetNextPriceSetterOrdersLoadingState extends AppStates{}

class AppGetNextPriceSetterOrdersSuccessState extends AppStates{}

class AppGetNextPriceSetterOrdersErrorState extends AppStates{}

//------------------------------------

//GET PAGINATED ORDERS INSPECTOR

class AppGetNextInspectorOrdersLoadingState extends AppStates{}

class AppGetNextInspectorOrdersSuccessState extends AppStates{}

class AppGetNextInspectorOrdersErrorState extends AppStates{}

//------------------------------------

//GET PAGINATED ORDERS

class AppGetNextOrdersLoadingState extends AppStates{}

class AppGetNextOrdersSuccessState extends AppStates{}

class AppGetNextOrdersErrorState extends AppStates{}

//------------------------------------