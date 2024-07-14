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

class AppGetWorkerSuccessState extends AppStates{}

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