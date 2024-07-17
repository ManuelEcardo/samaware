import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:page_transition/page_transition.dart';
import 'package:samaware_flutter/shared/bloc_observer.dart';
import 'package:samaware_flutter/shared/network/end_points.dart';
import 'package:samaware_flutter/shared/network/remote/main_dio_helper.dart';
import 'package:samaware_flutter/shared/styles/themes.dart';
import 'package:samaware_flutter/shared/components/Imports/conditional_import.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'layout/home_layout.dart';
import 'modules/Login/login.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  WebSocketChannel wsChannel = getWebSocketChannel(webSocketLocalHost); //Connecting to wsChannel through conditional imports

  //Fire Flutter Errors into Run Terminal
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
  };

  Bloc.observer = MyBlocObserver(); //Running Bloc Observer which prints change in states and errors etc...  in console

  //Dio Initialization
  MainDioHelper.init();

  await CacheHelper.init(); //Starting CacheHelper (SharedPreferences), await for it since there is async,await in .init().


  //LOAD LANGUAGE
  AppCubit.language= CacheHelper.getData(key: 'language');
  AppCubit.language ??= 'en';
  await Localization.load(Locale(AppCubit.language!)); // Set the initial locale

  bool? isDark = CacheHelper.getData(key: 'isDarkTheme'); //Getting the last Cached ThemeMode
  isDark ??= true;

  if (CacheHelper.getData(key: 'token') != null) {
    token = CacheHelper.getData(key: 'token'); // Get User Token
  }

  Widget widget; //to figure out which widget to send (login, onBoarding or HomePage) we use a widget and set the value in it depending on the token.

    if (token.isNotEmpty) //Token is there, so Logged in before
    {
      widget = const HomeLayout(); //Straight to Home Page.
    }

    else
    {
      widget= const Login();
    }


  runApp(MyApp(isDark: isDark, homeWidget: widget, wsChannel: wsChannel!,));
}

class MyApp extends StatelessWidget {

  final bool isDark;        //If the app last theme was dark or light
  final Widget homeWidget;  // Passing the widget to be loaded.

  final WebSocketChannel wsChannel; //Web Socket Channel to be received

  const MyApp({super.key, required this.isDark, required this.homeWidget, required this.wsChannel});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers:
        [
          BlocProvider(create: (BuildContext context) => AppCubit(wsChannel)..setListener()..changeTheme(themeFromState: isDark)..getUserData()..getMyAPI()
          ),
        ],
        child: BlocConsumer<AppCubit,AppStates>(
          listener: (context,state){},

          builder: (context,state)
          {
            var cubit=AppCubit.get(context);

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme(context),
              darkTheme: darkTheme(context),
              themeMode: AppCubit.get(context).isDarkTheme   //If the boolean says last used is dark (from Cache Helper) => Then load dark theme
                  ? ThemeMode.dark
                  : ThemeMode.light,

              home: Directionality(
                textDirection: appDirectionality(),

                child: AnimatedSplashScreen(
                  duration: 3000,
                  animationDuration: const Duration(milliseconds: 200),
                  splash: Image(
                    image: const AssetImage(
                      'assets/images/splash/alsamah.png',
                    ),
                    color: AppCubit.get(context).isDarkTheme? Colors.white : defaultHomeDarkColor,
                    fit: BoxFit.contain,
                    width: kIsWeb? 400 : 250,
                    height: kIsWeb? 400 : 250,
                  ),
                  splashIconSize: 150,
                  nextScreen: homeWidget,
                  splashTransition: SplashTransition.fadeTransition,
                  pageTransitionType: PageTransitionType.fade,
                  backgroundColor: cubit.isDarkTheme? defaultHomeDarkColor : defaultHomeColor,
                ),
              ),
              builder: EasyLoading.init(), //Toasts without context for web
            );
          },
        ),
    );
  }
}
