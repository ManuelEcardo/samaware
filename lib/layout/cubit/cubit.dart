import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_excel/excel.dart';
import 'package:samaware_flutter/models/InspectorsDetailsModel/InspectorsDetailsModel.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/PriceSettersDetailsModel/PriceSettersDetailsModel.dart';
import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/models/WorkerDetailsModel/WorkerDetailsModel.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorHome/InspectorHome.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorPreviousOrders/InspectorPreviousOrders.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorSettings/InspectorSettings.dart';
import 'package:samaware_flutter/modules/Login/login.dart';
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
import 'package:samaware_flutter/shared/network/end_points.dart';
import 'package:file_picker/file_picker.dart';

class AppCubit extends Cubit<AppStates>
{
  WebSocketChannel wsChannel; //Web Socket passed to AppCubit

  AppCubit(this.wsChannel):super(AppInitialState());

  static AppCubit get(context)=> BlocProvider.of(context);

  ///SET LISTENER FOR WEB SOCKETS, DEFAULT CALLED BY MAIN
  void setListener() {
    wsChannel.stream.listen((message)
    {
      //Parse JSON from String
      var jsonMessage= jsonDecode(message);

      if(jsonMessage['type'] !=null)
      {
        try
        {
          emit(AppWSOrderUpdateLoadingState());

          print('Got WS Message!, Type: ${jsonMessage['type']}');

          switch(jsonMessage['type'])
          {
            case 'order':
              getMyAPI(getAll: false); //was true
              break;

            default:
              break;
          }

          emit(AppWSOrderUpdateSuccessState());
        }

        catch (error)
        {
          print('ERROR WHILE RECEIVING WS MESSAGE, ${error.toString()}');
          emit(AppWSOrderUpdateErrorState());
        }

      }

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

      wsRegister(clientId: userData?.id); //re registering for web sockets
    }
  }


  /// Register the client in ws
  void wsRegister({required String? clientId})
  {
    if(wsChannel.closeCode != null || wsChannel.closeReason !=null)
    {
      _reConnectWsChannel();
    }

    if(token !='')
    {
      Map<String,dynamic> data=
      {
        "type":"register",
        "clientId":clientId,
        "token":token,
      };

      wsChannel.sink.add(jsonEncode(data));
      print('Registered in ws');
    }
    else
    {
      print('No token yet, cannot register ws');
    }
  }

  //------------------------------------\\

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
    emit(AppAlterBottomNavBarItemsLoadingState());

    if(role !=null)
      {
        switch (role)
        {
          case manager:
            bottomBarWidgets=
            [
              const ManagerHome(),
              const ManagerOrders(),
              const ManagerSettings(),
            ];
            break;

          case worker:
            bottomBarWidgets=
            [
              const WorkerHome(),
              const WorkerPreviousOrders(),
              const WorkerSettings(),
            ];
            break;

          case inspector:

            bottomBarWidgets=
            [
              const InspectorHome(),
              const InspectorPreviousOrders(),
              const InspectorSettings(),
            ];

            break;

          case priceSetter:

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


  //----------------------------------------------------\\

  ///Will Get the required data depending on the user's role
  void getMyAPI({bool getAll = false, bool GetUserData =false})
  {
    if(token !='')
    {
      if(GetUserData) getUserData();

      switch(CacheHelper.getData(key: 'role'))
      {
        case manager:
          print('Manager Role...');

          getWorkers();
          getPriceSetters();
          getInspectors();

          getNonReadyOrders();
          if(getAll) getAllOrders();

          break;

        case worker:
          print('Worker Role...');

          getWaitingOrders();
          getWorkerDoneOrders();


          if(getAll) getAllWorkerOrders();

          break;

        case priceSetter:
          print('Price Setter Role...');

          getWaitingOrdersPriceSetter();
          getPriceSetterDoneOrders();

          if(getAll) getAllPriceSetterOrders();

          break;

        case inspector:
          print('Inspector Role...');

          getWaitingOrdersInspector();
          getInspectorDoneOrders();

          if(getAll) getAllInspectorOrders();

          break;

        default:
          print('Default Role...');

          break;
      }
    }

    else
    {
      print('No Token was found');

      if(!kIsWeb) {
        defaultToast(msg: 'No Token was Found');
      }
    }
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

        print('In getUserData to wsRegister-> clientId:${userData?.id}');
        wsRegister(clientId: userData?.id);

        emit(AppGetUserDataSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING USER DATA, ${error.toString()}');
        emit(AppGetUserDataErrorState());
      });
    }
  }

  WorkersDetailsModel? workers;
  ///Gets the workers data for manager
  void getWorkers()
  {
    if(token!='')
      {
        emit(AppGetWorkersLoadingState());

        MainDioHelper.getData(
          url: workersForManager,
          token: token,
        ).then((value)
        {
          print('Got Workers Data...');

          workers = WorkersDetailsModel.fromJson(value.data);


          setChosenWorker(w:workers?.workers?[0].worker);

          emit(AppGetWorkersSuccessState());
        }).catchError((error, stackTrace)
        {
          print("COULDN'T GET WORKERS DATA FROM getWorkers, ${error.toString()}");

          print(stackTrace);

          emit(AppGetWorkersErrorState());
        });
      }
  }


  PriceSettersDetailsModel? priceSetters;
  ///Gets the priceSetters for manager
  void getPriceSetters()
  {
    if(token!='')
    {
      print('In getPriceSetters...');
      emit(AppGetPriceSettersLoadingState());

      MainDioHelper.getData(
        url: allPriceSetters,
        token: token
      ).then((value)
      {
        print('Got priceSetters...');

        priceSetters= PriceSettersDetailsModel.fromJson(value.data);

        emit(AppGetPriceSettersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING PRICE SETTERS, ${error.toString()}');
        emit(AppGetPriceSettersErrorState());
      });

    }
  }


  InspectorsDetailsModel? inspectors;
  ///Gets the inspectors for manager
  void getInspectors()
  {
    if(token!='')
    {
      print('In getInspectors...');
      emit(AppGetInspectorsLoadingState());

      MainDioHelper.getData(
          url: allInspectors,
          token: token
      ).then((value)
      {
        print('Got inspectors...');

        inspectors= InspectorsDetailsModel.fromJson(value.data);

        emit(AppGetInspectorsSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING INSPECTORS, ${error.toString()}');
        emit(AppGetInspectorsErrorState());
      });

    }
  }


  ///Logout User and Remove his token from back-end side
  bool logout({required BuildContext context, required String role})
  {
    emit(AppLogoutLoadingState());

    MainDioHelper.postData(
      url: logoutOneToken,
      data: {},
      token: token,
    ).then((value) {

      CacheHelper.saveData(key: 'token', value: '').then((value)
      {
        deleteAllData(role);

        defaultToast(msg: Localization.translate('logout_successfully_toast'));

        navigateAndFinish(context, const Login());
        emit(AppLogoutSuccessState());

        return true;

      }).catchError((error)
      {
        defaultToast(msg: error.toString());
        print('ERROR WHILE LOGGING OUT CACHE HELPER, ${error.toString()}');
        emit(AppLogoutErrorState());
        return false;
      });

    }).catchError((error)
    {
      print('ERROR WHILE LOGGING OUT, ${error.toString()}');
      emit(AppLogoutErrorState());
    });
    return false;
  }


  ///Delete and empty All models and classes
  void deleteAllData(String role)
  {
    CacheHelper.clearData(key: 'token');
    token='';

    currentBottomBarIndex=0;

    switch(role)
    {
      case manager:

        userData=null;
        allOrders=null;
        nonReadyOrders=null;

        //workersDetailsModel=null; //Todo is this deleted?
        workers=null;

        break;

      case worker:
        userData=null;
        workerDoneOrders=null;
        workerWaitingOrders=null;

        inWorkingOrder=null;
        workerDoneOrders=null;
        allWorkerOrders=null;

        break;

      case priceSetter:
        userData=null;
        priceSetterDoneOrders=null;
        priceSetterWaitingOrders=null;

        inWorkingOrder=null;
        priceSetterDoneOrders=null;
        allPriceSetterOrders=null;

        break;

      case inspector:

        break;

      default:
        break;

    }

  }

  //--------------------------------------------------\\

  //ORDER API

  ///Helper function to add the new orders for MANAGER
  void nextOrderHelperManager({required String type, required Response<dynamic> value, required String id})
  {
    switch(type)
    {
      case worker:

        for(WorkerWithDetailsModel worker in workers?.workers ?? [])
        {
          if(worker.worker?.id == id)
          {
            worker.addOrders(value.data);
            worker.addPagination(value.data);

            break;
          }
        }

        break;

      case priceSetter:

        for(PriceSetterDetailsModel priceSetter in priceSetters?.priceSetters ?? [])
        {
          if(priceSetter.priceSetter?.id == id)
          {
            priceSetter.addOrders(value.data);
            priceSetter.addPagination(value.data);

            break;
          }
        }

        break;

      case inspector:

        for(InspectorDetailsModel inspector in inspectors?.inspectors ?? [])
        {
          if(inspector.inspector?.id == id)
          {
            inspector.addOrders(value.data);
            inspector.addPagination(value.data);

            break;
          }
        }

        break;

      case 'allOrders':

        allOrders?.addOrders(value.data);
        allOrders?.addPagination(value.data);

        break;

        default:
        break;
    }
  }

  ///Helper function to add the new orders for other roles
  void nextOrderHelperRoles({required String type, required Response<dynamic> value})
  {
    switch(type)
    {
      case worker:

        allWorkerOrders?.addOrders(value.data);
        allWorkerOrders?.addPagination(value.data);

        break;

      case priceSetter:
        allPriceSetterOrders?.addOrders(value.data);
        allPriceSetterOrders?.addPagination(value.data);

        break;

      case inspector:
        allInspectorOrders?.addOrders(value.data);
        allInspectorOrders?.addPagination(value.data);

        break;


      default:
        break;
    }
  }

  //WORKER ROLE

  OrdersModel? workerWaitingOrders;
  ///Get Orders waiting for you
  void getWaitingOrders()
  {
    if(token!='')
    {
      emit(AppGetWorkerWaitingOrdersLoadingState());

      print('Worker, in getWaitingOrders...');

      MainDioHelper.getData(
        url: getAwaitingOrders,
        token: token,
      ).then((value)
      {
        print('Got waitingOrders...');

        workerWaitingOrders= OrdersModel.fromJson(value.data);

        emit(AppGetWorkerWaitingOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING WORKER WAITING ORDERS, ${error.toString()}');
        emit(AppGetWorkerWaitingOrdersErrorState());
      });
    }
  }


  ///Order in WorkerPrepareOrder
  OrderModel? inWorkingOrder;
  void setInWorkingOrder(OrderModel? o)
  {
    inWorkingOrder = o;
    emit(AppSetInWorkingOrderState());

  }


  OrdersModel? workerDoneOrders;
  ///Get the [being-prepared, prepared] orders by a worker
  void getWorkerDoneOrders()
  {
    if(token !='')
    {
      emit(AppGetWorkerDoneOrdersLoadingState());
      print("In Getting Worker's Done Orders...");

      MainDioHelper.getData(
        url: doneOrdersByUser,
        token: token,
      ).then((value)
      {
        print('Got Worker Done Orders...');

        workerDoneOrders = OrdersModel.fromJson(value.data);

        emit(AppGetWorkerDoneOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING WORKER DONE ORDERS, ${error.toString()}');
        emit(AppGetWorkerDoneOrdersErrorState());
      });
    }
  }


  OrdersModel? allWorkerOrders;
  ///Get all the orders assigned to this worker
  void getAllWorkerOrders()
  {
    if(token !='')
    {
      emit(AppGetAllOrdersWorkerLoadingState());

      print('In getAllWorkerOrders...');

      MainDioHelper.getData(
        url: allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('Got all Worker Orders...');

        allWorkerOrders= OrdersModel.fromJson(value.data);

        emit(AppGetAllOrdersWorkerSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING ALL ORDERS OF A WORKER, ${error.toString()}');
        emit(AppGetAllOrdersWorkerErrorState());
      });
    }
  }


  /// Get Next Paginated Orders, Worker type
  void getNextWorkerOrdersWorker({String? nextPage})
  {
    if(token != '')
    {
      emit(AppGetNextWorkerWOrdersLoadingState());
      print('in getNextWorkerOrdersWorker...');

      MainDioHelper.getData(
        url: nextPage != null ? '$allOrdersUsers$nextPage' : allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('got next worker orders w...');

        nextOrderHelperRoles(value: value, type: worker);

        emit(AppGetNextWorkerWOrdersSuccessState());
      }).catchError((error)
      {
        print("COULDN'T GET NEXT ORDERS WORKER W, ${error.toString()}");

        emit(AppGetNextWorkerWOrdersErrorState());
      });
    }
  }

  ///Gets next batch of orders for worker
  void getNextWorkerOrdersManager({String? nextPage, required String id})
  {
    emit(AppGetNextWorkerMOrdersLoadingState());

    print('In getNextWorkerOrders...');

    MainDioHelper.getData(
        url: nextPage !=null ? '$workerOrders/$id$nextPage' : '$workerOrders/$id',
        token: token
    ).then((value)
    {
      print('Got next worker orders...');

      nextOrderHelperManager(id: id, type: worker, value: value);

      emit(AppGetNextWorkerMOrdersSuccessState());
    }).catchError((error)
    {
      print("COULDN'T GET NEXT WORKER ORDERS, ${error.toString()}");
      emit(AppGetNextWorkerMOrdersErrorState());
    });
  }

  //--------------------------
  //--------------------------

  // PRICE SETTER ROLE


  OrdersModel? priceSetterWaitingOrders;
  ///Get Orders waiting for you
  void getWaitingOrdersPriceSetter()
  {
    if(token!='')
    {
      emit(AppGetPriceSetterWaitingOrdersLoadingState());

      print('Price Setter, in getWaitingOrders...');

      MainDioHelper.getData(
        url: getAwaitingOrdersPriceSetters,
        token: token,
      ).then((value)
      {
        print('Got priceSetter waitingOrders...');

        priceSetterWaitingOrders= OrdersModel.fromJson(value.data);

        emit(AppGetPriceSetterWaitingOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING PRICE SETTER WAITING ORDERS, ${error.toString()}');
        emit(AppGetPriceSetterWaitingOrdersErrorState());
      });
    }
  }


  OrdersModel? priceSetterDoneOrders;
  ///Get the [priced, being_priced] orders by a priceSetter
  void getPriceSetterDoneOrders()
  {
    if(token !='')
    {
      emit(AppGetPriceSetterDoneOrdersLoadingState());
      print("In Getting Price Setter's Done Orders...");

      MainDioHelper.getData(
        url: doneOrdersByUser,
        token: token,
      ).then((value)
      {
        print('Got Price Setter Done Orders...');

        priceSetterDoneOrders = OrdersModel.fromJson(value.data);

        emit(AppGetPriceSetterDoneOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING PRICE SETTER DONE ORDERS, ${error.toString()}');
        emit(AppGetPriceSetterDoneOrdersErrorState());
      });
    }
  }


  OrdersModel? allPriceSetterOrders;
  ///Get all the orders assigned to this priceSetter
  void getAllPriceSetterOrders()
  {
    if(token !='')
    {
      emit(AppGetAllOrdersPriceSetterLoadingState());

      print('In getAllPriceSetterOrders...');

      MainDioHelper.getData(
        url: allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('Got all Price Setters Orders...');

        allPriceSetterOrders= OrdersModel.fromJson(value.data);

        emit(AppGetAllOrdersPriceSetterSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING ALL ORDERS OF A PRICE SETTER, ${error.toString()}');

        emit(AppGetAllOrdersPriceSetterErrorState());
      });
    }
  }

  /// Get Next Paginated Orders, PriceSetter type
  void getNextWorkerOrdersPriceSetter({String? nextPage})
  {
    if(token != '')
    {
      emit(AppGetNextPriceSetterOrdersPLoadingState());
      print('in getNextWorkerOrdersPriceSetter...');

      MainDioHelper.getData(
        url: nextPage != null ? '$allOrdersUsers$nextPage' : allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('got next priceSetter orders w...');

        nextOrderHelperRoles(value: value, type: priceSetter);

        emit(AppGetNextPriceSetterOrdersPSuccessState());
      }).catchError((error)
      {
        print("COULDN'T GET NEXT ORDERS PRICE-SETTER P, ${error.toString()}");

        emit(AppGetNextPriceSetterOrdersPErrorState());
      });
    }
  }


  ///Gets next batch of orders for priceSetter
  void getNextPriceSetterOrdersManager({String? nextPage, required String id})
  {
    emit(AppGetNextPriceSetterMOrdersLoadingState());
    print('In getNextPriceSetterOrders...');

    MainDioHelper.getData(
        url: nextPage !=null ? '$priceSetterOrders/$id$nextPage' : '$priceSetterOrders/$id',
        token: token
    ).then((value)
    {
      print('Got next priceSetter orders...');

      nextOrderHelperManager(id: id, type: priceSetter, value: value);

      emit(AppGetNextPriceSetterMOrdersSuccessState());
    }).catchError((error)
    {
      print("COULDN'T GET NEXT PRICE SETTER ORDERS, ${error.toString()}");
      emit(AppGetNextPriceSetterMOrdersErrorState());
    });
  }

  //--------------------------
  //--------------------------

  // INSPECTOR ROLE

  OrdersModel? inspectorWaitingOrders;
  ///Get Orders waiting for you
  void getWaitingOrdersInspector()
  {
    if(token!='')
    {
      emit(AppGetInspectorWaitingOrdersLoadingState());

      print('Inspector, in getWaitingOrders...');

      MainDioHelper.getData(
        url: getAwaitingOrdersInspector,
        token: token,
      ).then((value)
      {
        print('Got Inspector waitingOrders...');

        inspectorWaitingOrders= OrdersModel.fromJson(value.data);

        emit(AppGetInspectorWaitingOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING INSPECTOR WAITING ORDERS, ${error.toString()}');
        emit(AppGetInspectorWaitingOrdersErrorState());
      });
    }
  }

  OrdersModel? inspectorDoneOrders;
  ///Get the [verified, being_verified] orders by an inspector
  void getInspectorDoneOrders()
  {
    if(token !='')
    {
      emit(AppGetInspectorDoneOrdersLoadingState());
      print("In Getting inspector's Done Orders...");

      MainDioHelper.getData(
        url: doneOrdersByUser,
        token: token,
      ).then((value)
      {
        print('Got inspector Done Orders...');

        inspectorDoneOrders = OrdersModel.fromJson(value.data);

        emit(AppGetInspectorDoneOrdersSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING INSPECTOR DONE ORDERS, ${error.toString()}');
        emit(AppGetInspectorDoneOrdersErrorState());
      });
    }
  }


  OrdersModel? allInspectorOrders;
  ///Get all the orders assigned to this inspector
  void getAllInspectorOrders()
  {
    if(token !='')
    {
      emit(AppGetAllOrdersInspectorLoadingState());

      print('In getAllInspectorOrders...');

      MainDioHelper.getData(
        url: allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('Got all inspector Orders...');

        allInspectorOrders= OrdersModel.fromJson(value.data);

        emit(AppGetAllOrdersInspectorSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE GETTING ALL ORDERS OF AN INSPECTOR, ${error.toString()}');

        emit(AppGetAllOrdersInspectorErrorState());
      });
    }
  }


  /// Get Next Paginated Orders, Inspector type
  void getNextWorkerOrdersInspector({String? nextPage})
  {
    if(token != '')
    {
      emit(AppGetNextInspectorOrdersILoadingState());
      print('in getNextWorkerOrdersInspector...');

      MainDioHelper.getData(
        url: nextPage != null ? '$allOrdersUsers$nextPage' : allOrdersUsers,
        token: token,
      ).then((value)
      {
        print('got next Inspector orders w...');

        nextOrderHelperRoles(value: value, type: inspector);

        emit(AppGetNextInspectorOrdersISuccessState());
      }).catchError((error)
      {
        print("COULDN'T GET NEXT ORDERS INSPECTOR I, ${error.toString()}");

        emit(AppGetNextInspectorOrdersIErrorState());
      });
    }
  }

  ///Gets next batch of orders for inspector
  void getNextInspectorOrdersManager({String? nextPage, required String id})
  {
    emit(AppGetNextInspectorOrdersMLoadingState());
    print('In getNextInspectorOrders...');

    MainDioHelper.getData(
        url: nextPage !=null ? '$inspectorOrders/$id$nextPage' : '$inspectorOrders/$id',
        token: token
    ).then((value)
    {
      print('Got next inspector orders...');

      nextOrderHelperManager(id: id, type: inspector, value: value);

      emit(AppGetNextInspectorOrdersMSuccessState());
    }).catchError((error)
    {
      print("COULDN'T GET NEXT INSPECTOR ORDERS, ${error.toString()}");
      emit(AppGetNextInspectorOrdersMErrorState());
    });

  }

  //----------------------

  //GLOBAL ORDERS

  ///Create an Order
  void createOrder(SubmitOrderModel? order, BuildContext context)
  {
    print('Creating Order...');
    emit(AppCreateOrderLoadingState());

    defaultToast(msg: Localization.translate('order_submit_loading_toast'));

    print('Current Order: ${order.toString()}');

    List<Map<String,dynamic>> orderItems=[];

    order?.items?.forEach((item)
    {
      orderItems.add({
        'itemId':'${item.itemId}',
        'quantity':'${item.quantity}',
        'type':orderItemTypeFormatter(item.type!),
      });
    });

    MainDioHelper.postData(
      url: createAnOrder,
      data:
      {
        'orderId':order?.orderId,
        'registration_date':order?.registrationDate,
        'shipping_date':order?.shippingDate,
        'workerId':order?.workerId,
        'clientId':order?.clientId,
        'waiting_to_be_prepared_date': defaultDateFormatter.format(DateTime.now()),

        'items':orderItems,
      },
      token: token,
    ).then((value)
    {
      print('Got createOrder data...');

      defaultToast(msg: Localization.translate('order_submit_done_toast'));

      getNonReadyOrders();

      emit(AppCreateOrderSuccessState());

      Navigator.of(context).pop(true);

    }).catchError((error)
    {
      print('ERROR WHILE CREATING AN ORDER, ${error.toString()}');

      defaultToast(msg: '${Localization.translate('order_submit_error_toast')}, ${error.toString()}');

      emit(AppCreateOrderErrorState());
    });
  }


  OrdersModel? nonReadyOrders;
  ///Get Non-Ready Orders; anything not Shipped, Stored or Failed
  void getNonReadyOrders()
  {
    if(token !='')
      {
        print('Getting Non-Ready Orders...');

        emit(AppGetNonReadyOrdersLoadingState());

        MainDioHelper.getData(
          url: notReadyOrders,
          token: token,
        ).then((value)
        {
          print('Got Non Ready Orders data...');

          nonReadyOrders = OrdersModel.fromJson(value.data);


          emit(AppGetNonReadyOrdersSuccessState());
        }).catchError((error, stackTrace)
        {
          print('COULD NOT GET NON READY ORDERS, ${error.toString()}');

          print(stackTrace);
          emit(AppGetNonReadyOrdersErrorState());
        });
      }
  }


  OrdersModel? allOrders;
  ///Get All Orders in the system
  void getAllOrders()
  {
    if(token!='')
    {
      print('In getAllOrders...');

      emit(AppGetAllOrdersLoadingState());

      MainDioHelper.getData(
        url: AllOrders,
        token: token
      ).then((value)
      {
        print('Got all orders...');

        allOrders=OrdersModel.fromJson(value.data);

        emit(AppGetAllOrdersSuccessState());

      }).catchError((error)
      {
        print("ERROR WHILE GETTING ALL ORDERS, ${error.toString()}");

        emit(AppGetAllOrdersErrorState());
      });
    }
  }


  ///Gets next batch of total orders
  void getNextOrders({String? nextPage})
  {
    emit(AppGetNextOrdersLoadingState());

    print('In getNextOrders...');

    MainDioHelper.getData(
        url: nextPage !=null ? '$AllOrders$nextPage' : AllOrders,
        token: token
    ).then((value)
    {
      print('Got next  orders...');

      nextOrderHelperManager(id: 'none', type: 'allOrders', value: value);

      emit(AppGetNextOrdersSuccessState());
    }).catchError((error)
    {
      print("COULDN'T GET NEXT ORDERS, ${error.toString()}");
      emit(AppGetNextOrdersErrorState());
    });
  }

  ///Updates an order
  void patchOrder({
    bool? isWorkerWaitingOrders, bool? getDoneOrdersWorker,
    bool? isPriceSetterWaitingOrders, bool? getDoneOrdersPriceSetter,
    bool? isInspectorWaitingOrders, bool? getDoneOrdersInspector,
    bool? designatePriceSetter, bool? designateInspector,
    String? userId,
    required String orderId, required OrderState status,
    OrderDate? dateType, String? date,

  })
  {
    if(token!='')
    {
      emit(AppPatchOrderLoadingState());
      print('in patching order with id: $orderId');

      MainDioHelper.patchData(
        url: patchAnOrder,
        data:
        {
          "id":orderId,
          "status":status.name,
          if(dateType!=null) dateType.name:date,
          if(designatePriceSetter !=null && userId !=null) "priceSetterId":userId,
          if(designateInspector !=null && userId !=null) "inspectorId":userId,
        },
        token: token,
      ).then((value)
      {
        print('Got patch order data....');

        isWorkerWaitingOrders!=null ? getWaitingOrders() : null;
        getDoneOrdersWorker !=null? getWorkerDoneOrders() : null;

        isPriceSetterWaitingOrders !=null? getWaitingOrdersPriceSetter() : null;
        getDoneOrdersPriceSetter !=null? getPriceSetterDoneOrders() : null;

        isInspectorWaitingOrders !=null? getWaitingOrdersInspector(): null;
        getDoneOrdersInspector !=null? getInspectorDoneOrders() :null;

        getMyAPI(); //Update the data

        emit(AppPatchOrderSuccessState());
      }).catchError((error)
      {
        print('ERROR WHILE PATCHING ORDER, ${error.toString()}');
        emit(AppPatchOrderErrorState());
      });
    }
  }



  //--------------------------------------------------------\\

  //Order FILE CREATED BY MANAGER

  SubmitOrderModel? orderFromExcel;

  PlatformFile? excelFile;


  ///Set the picked file for the excelFile
  void setExcelFile(PlatformFile file)
  {
    excelFile=file;

    emit(AppSetExcelFileState());
  }

  ///Reading the excel file and serializing it to object
  void readFileAndExtractData(PlatformFile file)
  {
    try {

      emit(AppExtractExcelFileLoadingState());

      var bytes = getFilePathOrBytes(file);

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys)
      {

        if (excel.tables[table] != null)
        {
          final sheet = excel.tables[table]!;

          //print("Rows Number: ${sheet.maxRows}");

          int id=0;
          String registrationDate='';
          String shippingDate='';

          List<OrderItem>? items=[];

          // Extracting the first row for order information
          final firstRow = sheet.row(0);

          //Get Order date and registration data
          for (var cellIndex = 0; cellIndex < firstRow.length; cellIndex++)
          {
            final cell = firstRow[cellIndex];
            if (cell != null)
            {
              if (cell.value.toString().contains('رقم الطلب'))
              {
                String cellValue = cell.value.toString();
                RegExp regExp = RegExp(r'\d+');
                Match? match = regExp.firstMatch(cellValue);
                if (match != null)
                {

                  //Set Id
                  id= (int.tryParse(match.group(0) ?? '0') ?? 0) ;


                  if (cellValue.contains('تاريخ التسجيل')) {
                    final parts = cellValue.split('تاريخ التسجيل');
                    if (parts.length > 1) {
                      final remaining = parts[1];
                      final dateParts = remaining.split('تاريخ التسليم');

                      //print('Registration Date: ${dateParts[0].trim()}');

                      registrationDate = dateParts[0].trim();
                    }
                  }

                  if (cellValue.contains('تاريخ التسليم')) {
                    final parts = cellValue.split('تاريخ التسليم');
                    if (parts.length > 1){
                      //print('Shipping Date: ${parts[1].trim()}');

                      shippingDate=parts[1].trim();
                    }
                  }

                }
              }

            }
          }

          //Get Items
          for (var rowIndex = 4; rowIndex < sheet.maxRows; rowIndex++) {
            final row = sheet.row(rowIndex);

            final id = row[1];
            final itemName = row[2];
            final quantity = row[3];
            final type = row[4];

            if (id != null && itemName != null && quantity != null && type != null)
            {
              final item = OrderItem(
                itemId: id.value.toString(),
                name: itemName.value.toString(),
                quantity: double.tryParse(quantity.value.toString()) ?? 0,
                type: type.value.toString(),
              );

              bool isFound=false;
              //If any redundant item was found => just change the quantity
              for(var i in items)
              {
                if(item.name == i.name && item.type == i.type)
                  {
                    i.setQuantity(i.quantity! + item.quantity!);
                    isFound=true;

                    break;
                  }
              }
              if(!isFound)
              {
                items.add(item);
              }


            }
          }
          print('Items number is ${items.length}');
          orderFromExcel= SubmitOrderModel.create(id: '$id', regDate: registrationDate, shipDate: shippingDate, itemList: items,);
          emit(AppExtractExcelFileSuccessState());
        }


      }
    }
    catch (e, stackTrace)
    {
      print("Error while manipulating the excel file, $e");
      print(stackTrace.toString());

      emit(AppExtractExcelFileErrorState());
    }
  }


  ///Clear Order & ExcelFiles
  void clearOrder()
  {
    orderFromExcel=null;
    excelFile=null;

    emit(AppClearOrderState());
  }


  ///Change an Item Quantity
  void changeQuantity({required OrderItem item, bool isLongPressed=false, bool isIncrease=true})
  {
        orderFromExcel!.items?.forEach((i)
        {
          if(item.itemId! == i.itemId!)
          {

            // isLongPressed
            // ?(isIncrease
            //     ?(i.setQuantity(i.quantity!+0.5))
            //     :(i.setQuantity(i.quantity!-0.5))
            // )
            // :(isIncrease
            //     ?(i.setQuantity(i.quantity!+1))
            //     :(i.setQuantity(i.quantity!-1))
            // );

            if(isIncrease)
              {
                if(isLongPressed)
                  {
                    i.setQuantity(i.quantity!+0.5);
                  }
                else
                  {
                    i.setQuantity(i.quantity!+1);
                  }
              }

            else
              {
                if(isLongPressed)
                {
                  i.quantity!>0.5? i.setQuantity(i.quantity!-0.5) : null ;
                }
                else
                {
                  i.quantity!>1? i.setQuantity(i.quantity!-1) : null ;
                }
              }

            emit(AppChangeItemQuantityState());
          }
        });
  }


  ///Remove an item from list

  void removeItemFromOrder(OrderItem item)
  {
    orderFromExcel?.items?.remove(item);

    emit(AppRemoveItemState());
  }

  ///Returns Path for Android and Bytes for Web/IOS
  getFilePathOrBytes(PlatformFile file)
  {
    if(kIsWeb)
      {
        return file.bytes;
      }
    return File(file.path!).readAsBytesSync();
  }

  //The Worker chosen to do the order
  UserData? chosenWorker;

  ///Sets the chosen worker for this job
  void setChosenWorker({String? id, UserData? w})
  {
    if(id !=null)
      {
        for(WorkerWithDetailsModel worker in workers?.workers??[])
        {
          if (worker.worker?.id == id)
          {
            chosenWorker = worker.worker;
            orderFromExcel?.workerId=worker.worker?.id;

            emit(AppSetChosenWorkerState());
            break; // Break out of the loop when the worker is found
          }
        }
        // workers?.workers?.forEach((worker)
        // {
        //   if(worker.id == id)
        //     {
        //       chosenWorker=worker;
        //     }
        // });
      }
    else
      {
        chosenWorker=w;

        orderFromExcel?.workerId=w?.id;
      }
    emit(AppSetChosenWorkerState());
  }


  // // TO BE DELETED , add total items
  //
  // List<Map<String, dynamic>> map=[];
  //
  // /// Add items to Database
  // Future<void> toDatabase()
  // async {
  //   emit(AppAddDatabaseLoadingState());
  //
  //   if(map.isEmpty)
  //   {
  //     print('empty  map');
  //     await loadAllItems();
  //   }
  //
  //   MainDioHelper.postData(
  //     url: 'items/addItem',
  //     data: {
  //       'data':map,
  //       token:token,
  //     },
  //     isStatusCheck: true
  //   ).then((value)
  //   {
  //     print(value.data);
  //     emit(AppAddDatabaseSuccessState());
  //   }).catchError((error, stackTrace)
  //   {
  //     print('ERROR, ${error.toString()}, $stackTrace');
  //
  //     emit(AppAddDatabaseErrorState());
  //   });
  // }
  //
  // /// Method to fetch the items from excel file
  // Future<void> loadAllItems() async {
  //   FilePickerResult? result=await FilePicker.platform.pickFiles();
  //
  //   if(result !=null)
  //   {
  //     var file = result.files.first.path!;
  //
  //     print("PATH IS: $file");
  //
  //     try
  //     {
  //       var bytes = File(file).readAsBytesSync();
  //
  //       var excel = Excel.decodeBytes(bytes);
  //
  //       for (var table in excel.tables.keys)
  //       {
  //         if (excel.tables[table] != null)
  //         {
  //           final sheet = excel.tables[table]!;
  //
  //           print("Rows: ${sheet.maxRows}");
  //
  //           //Get Items
  //           for (var rowIndex = 4; rowIndex < sheet.maxRows; rowIndex++) {
  //             final row = sheet.row(rowIndex);
  //
  //             final id = row[0];
  //             final itemName = row[1];
  //
  //             if (id != null && itemName != null )
  //             {
  //               map.add({
  //                 'itemId': id.value.toString(),
  //                 'name': itemName.value.toString(),
  //               });
  //             }
  //             else
  //             {
  //               print("Some row is null");
  //             }
  //           }
  //         }
  //       }
  //
  //     }
  //
  //     catch (e, stackTrace)
  //     {
  //       print("Error while reading files, $e");
  //       print(stackTrace.toString());
  //     }
  //
  //   }
  //
  //
  //   return null;
  // }

}