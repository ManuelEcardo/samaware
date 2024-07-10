import 'dart:convert';

import 'package:samaware_flutter/modules/Inspector/InspectorHome/InspectorHome.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorPreviousOrders/InspectorPreviousOrders.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorSettings/InspectorSettings.dart';
import 'package:samaware_flutter/modules/Manager/ManagerHome/ManagerHome.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrders/ManagerOrders.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/ManagerSettings.dart';
import 'package:samaware_flutter/modules/PriceSetter/PriceSetterHome/PriceSetterHome.dart';
import 'package:samaware_flutter/modules/PriceSetter/PriceSetterPreviousOrders/PriceSetterPreviousOrders.dart';
import 'package:samaware_flutter/modules/PriceSetter/PriceSetterSettings/PriceSetterSettings.dart';
import 'package:samaware_flutter/modules/Worker/WorkerHome/WorkerHome.dart';
import 'package:samaware_flutter/modules/Worker/WorkerPreviousOrders/WorkerPreviousOrders.dart';
import 'package:samaware_flutter/modules/Worker/WorkerSettings/WorkerSettings.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/models/UserDataModel/UserData.dart';
import 'package:samaware_flutter/shared/network/remote/main_dio_helper.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:samaware_flutter/shared/components/Imports/conditional_import_io.dart';
import 'package:samaware_flutter/shared/components/constants.dart';
import 'package:samaware_flutter/shared/network/end_points.dart';
import 'package:samaware_flutter/shared/network/local/cache_helper.dart';

class AppCubit extends Cubit<AppStates>
{
  WebSocketChannel wsChannel; //Web Socket passed to AppCubit

  AppCubit(this.wsChannel):super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  ///SET LISTENER FOR WEB SOCKETS, DEFAULT CALLED BY MAIN  //IOWebSocketChannel awsChannel
  void setListener() {
    wsChannel.stream.listen((message)
    {
      //Parse JSON from String
      var jsonMessage= jsonDecode(message);

      // if(jsonMessage['posts']!=null)
      // {
      //   print('Got WS Message!, ${jsonMessage['type']}');
      //
      //   Post post= Post.fromJson(jsonMessage['posts']);
      //
      //   switch (jsonMessage['type'])
      //   {
      //     case 'like':
      //       wsLike(post);
      //       break;
      //
      //     case 'add_comment':
      //       wsComments(post);
      //       break;
      //
      //     case 'delete_comment':
      //       wsComments(post);
      //       break;
      //
      //     case 'delete_post':
      //       wsDeletePost(post);
      //       break;
      //
      //     default:
      //       print('WS Message Does not convey any types');
      //       break;
      //
      //   }
      //
      // }
      //
      // else
      // {
      //   print(jsonMessage);
      // }
    },

        onError: (error,stackTrace)
        {
          print('WebSocket has been closed for an error, ${error.toString()}, reconnecting in 3 Seconds');

          //_reConnectWsChannel();

          defaultToast(msg: 'Reconnecting in 3 Seconds...');

          Future.delayed(const Duration(seconds: 3)).then((value) =>_reConnectWsChannel());
        },

        onDone: ()
        {
          print('WebSocket fired onDone function, Reason:${wsChannel.closeReason}, reconnecting in 3 Seconds...');

          defaultToast(msg: 'Reconnecting in 3 Seconds...');

          Future.delayed(const Duration(seconds: 3)).then((value) =>_reConnectWsChannel());
        }
    );
  }

  /// Re-connect and listen to wsChannel
  void _reConnectWsChannel()
  {
    if(wsChannel !=null && wsChannel.sink !=null && wsChannel.closeCode !=null)
    {
      print('Closing Connection before initializing another...');
      //Close previous connection
      wsChannel.sink.close();
    }

    if(isActive)
    {
      print('Reconnecting WSChannel, app is Active ');
      wsChannel= getWebSocketChannel(webSocketLocalHost); //IOWebSocketChannel.connect(webSocketLocalHost);
      setListener();  //wsChannel
    }
  }


  ///List of BottomBarWidgets, Home, TextFiles, ChatBot and Profile
  List<Widget> bottomBarWidgets=
  [
    const ManagerHome(),
    const ManagerOrders(),
    const ManagerSettings(),
  ];

  int currentBottomBarIndex = 0;

  ///Change Bottom Navigation Bar into another
  void changeBottomNavBar(int index) {
    currentBottomBarIndex = index;

    emit(AppChangeBottomNavBar());
  }


  ///Alter the BottomNavBarItems Depending on User's Role; manager, worker, etc...
  void alterBottomNavBarItems(String? role)
  {
    if(role !=null)
      {
        switch (role)
        {
          case 'manager':
            bottomBarWidgets=
            [
              const ManagerHome(),
              const ManagerOrders(),
              const ManagerSettings(),
            ];
            break;

          case 'worker':
            bottomBarWidgets=
            [
              const WorkerHome(),
              const WorkerPreviousOrders(),
              const WorkerSettings(),
            ];
            break;

          case 'inspector':

            bottomBarWidgets=
            [
              const InspectorHome(),
              const InspectorPreviousOrders(),
              const InspectorSettings(),
            ];

            break;

          case 'priceSetter':

            bottomBarWidgets=
            [
              const PriceSetterHome(),
              const PriceSetterPreviousOrders(),
              const PriceSetterSettings(),
            ];

            break;

          default:
            break;
        }

        emit(AppAlterBottomNavBarItemsSuccessState());
      }

    else
    {
      print("Couldn't change bottom bar items, role is null");

      emit(AppAlterBottomNavBarItemsErrorState());
    }
  }


  //DARK MODE
  bool isDarkTheme = false; //Check if the theme is Dark.

  ///Change Theme
  void changeTheme({bool? themeFromState}) {
    if (themeFromState != null) //if a value is sent from main, then use it.. we didn't use CacheHelper because the value has already came from cache, then there is no need to..
        {
      isDarkTheme = themeFromState;
      emit(AppChangeThemeModeState());
    } else // else which means that the button of changing the theme has been pressed.
        {
      isDarkTheme = !isDarkTheme;
      CacheHelper.putBoolean(key: 'isDarkTheme', value: isDarkTheme).then((value) //Put the data in the sharedPref and then emit the change.
      {
        emit(AppChangeThemeModeState());
      });
    }
  }


  ///Current Language Code
  static String? language='';

  ///Change Language
  void changeLanguage(String lang) async
  {
    language=lang;
    emit(AppChangeLanguageState());
  }


  //--------------------------------------------------\\

  //USER APIS


  static UserData? userData;
  void getUserData()
  {
    if (token !='')
    {
      print('In getting user data');

      emit(AppGetUserDataLoadingState());

      MainDioHelper.getData(
        url: userDataByToken,
        token: token,
      ).then((value)
      {
        print('Got User Data...');

        userData= UserData.fromJson(value.data);

        alterBottomNavBarItems(userData?.role);

        emit(AppGetUserDataSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING USER DATA, ${error.toString()}');
        emit(AppGetUserDataErrorState());
      });
    }
  }



}