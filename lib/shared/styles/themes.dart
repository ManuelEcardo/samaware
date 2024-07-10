import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../layout/cubit/cubit.dart';
import 'colors.dart';

//Refer to: https://docs.flutter.dev/release/breaking-changes/theme-data-accent-properties
//Refer to: https://github.com/flutter/flutter/issues/91605

ThemeData lightTheme(context) => ThemeData(
  // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,

  colorScheme: ColorScheme.fromSwatch(primarySwatch: defaultColor).copyWith(
    surface: defaultHomeColor,
    primary: defaultColor,
    secondary: defaultSecondaryColor,

  ),

  canvasColor: defaultCanvasColor,

  primarySwatch: defaultColor,

  scaffoldBackgroundColor: defaultHomeColor,

  appBarTheme:  AppBarTheme(
    titleSpacing: 16.0,
    backgroundColor: defaultHomeColor,
    elevation: 0.0,
    iconTheme: const IconThemeData(color: Colors.black),
    surfaceTintColor: Colors.transparent,

    titleTextStyle: TextStyle(color: defaultColor, fontWeight: FontWeight.bold, fontSize: 20),

    systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarColor: defaultHomeColor,
        statusBarIconBrightness: Brightness.dark
    ),

  ),


  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: defaultColor,
    elevation: 20,
    backgroundColor: defaultBottomNavBarColor,

  ),

  datePickerTheme: DatePickerThemeData(
    backgroundColor: defaultHomeColor,
    // headerForegroundColor: defaultThirdColor,
    elevation: 4,
  ),

  progressIndicatorTheme:  ProgressIndicatorThemeData(
    color: defaultColor,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: defaultColor,
      foregroundColor: Colors.white  //Element inside Color
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(defaultColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),

  switchTheme: SwitchThemeData(

    thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      if (states.contains(WidgetState.disabled)) {
        return Colors.white;
      }
      return defaultColor;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      if (states.contains(WidgetState.disabled)) {
        return Colors.white;
      }
      return defaultBottomNavBarColor;
    }),
  ),

  iconTheme: const IconThemeData(
      color: Colors.black
  ),

  inputDecorationTheme: const InputDecorationTheme(
    prefixIconColor: Colors.black,
    suffixIconColor: Colors.black,

    labelStyle: TextStyle(
        color: Colors.black
    ),

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),

  ),

  bottomSheetTheme:  BottomSheetThemeData(
    backgroundColor: defaultColor,
    modalBackgroundColor: Colors.white,
  ),

  navigationBarTheme:  NavigationBarThemeData(
    backgroundColor: defaultHomeColor,
    indicatorColor: Colors.white,
  ),

  textTheme: Theme.of(context).textTheme.apply(
    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'PT_Sans',
    bodyColor: Colors.black,
    displayColor: Colors.black,),



);


ThemeData darkTheme(context)=> ThemeData(
  useMaterial3: true,

  colorScheme: ColorScheme.fromSwatch(primarySwatch: defaultDarkColor).copyWith(
    surface: defaultHomeDarkColor,
    secondary: defaultSecondaryDarkColor,
    primary: defaultDarkColor,

  ),

  scaffoldBackgroundColor: defaultHomeDarkColor,

  canvasColor: defaultCanvasDarkColor,

  appBarTheme:  AppBarTheme(
    titleSpacing: 16.0,
    backgroundColor: defaultHomeDarkColor,
    elevation: 0.0,
    iconTheme: const IconThemeData(color: Colors.white),
    titleTextStyle:TextStyle(color: defaultDarkColor, fontWeight: FontWeight.bold, fontSize: 20),
    surfaceTintColor: Colors.transparent,

    actionsIconTheme: const IconThemeData(color: Colors.white),
    systemOverlayStyle:  SystemUiOverlayStyle(
        statusBarColor: defaultHomeDarkColor,
        statusBarIconBrightness: Brightness.light
    ),

  ),

  datePickerTheme: DatePickerThemeData(

    backgroundColor: defaultBoxDarkColor,
    shadowColor: defaultDarkFontColor,
    elevation: 4,
    yearForegroundColor: WidgetStateProperty.all(Colors.white),
    dayForegroundColor: WidgetStateProperty.resolveWith((states)
    {
      if(states.contains(WidgetState.disabled))
      {
        return Colors.black26;
      }

      if(states.contains(WidgetState.selected))
      {
        return Colors.black;
      }

      return Colors.white;
    }),
    headerForegroundColor: defaultThirdDarkColor,
    weekdayStyle: TextStyle(color: defaultSecondaryDarkColor),

    dayBackgroundColor: WidgetStateProperty.resolveWith((states) {


      if (states.contains(WidgetState.selected)) {
        return defaultDarkColor;
      }
      return null;
    }),



  ),

  bottomNavigationBarTheme:  BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: defaultBottomNavBarDarkColor,
    selectedItemColor: defaultDarkColor,
    unselectedIconTheme: const IconThemeData(color: Colors.white,),
    unselectedItemColor: Colors.white,
    elevation: 20,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: defaultDarkColor,
      foregroundColor: Colors.white  //Element inside Color
  ),

  progressIndicatorTheme:  ProgressIndicatorThemeData(
    color: defaultDarkColor,
  ),

  switchTheme: SwitchThemeData(

    thumbColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.white;
      }
      if (states.contains(WidgetState.disabled)) {
        return Colors.white;
      }
      return Colors.grey;
    }),
    trackColor: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
      if (states.contains(WidgetState.selected)) {
        return Colors.black;
      }
      if (states.contains(WidgetState.disabled)) {
        return Colors.white;
      }
      return Colors.white;
    }),
  ),


  iconTheme: const IconThemeData(
      color: Colors.white
  ),
  //
  inputDecorationTheme: const InputDecorationTheme(
    prefixIconColor: Colors.grey,
    suffixIconColor: Colors.grey,
    labelStyle: TextStyle(
        color: Colors.white
    ),

    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white),
    ),

  ),

  bottomSheetTheme:  BottomSheetThemeData(
    backgroundColor: defaultHomeDarkColor,
    modalBackgroundColor: Colors.white,
  ),

  navigationBarTheme:  NavigationBarThemeData(
    backgroundColor: defaultHomeDarkColor,
    indicatorColor: Colors.white,
  ),

  //Elevated Buttons Theme
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(defaultDarkColor),
      foregroundColor: WidgetStateProperty.all(Colors.white),
    ),
  ),



  textTheme: Theme.of(context).textTheme.apply(
    bodyColor: Colors.white,
    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'PT_Sans',
    displayColor: Colors.white,

  ),


);
