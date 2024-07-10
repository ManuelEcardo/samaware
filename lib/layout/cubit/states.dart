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