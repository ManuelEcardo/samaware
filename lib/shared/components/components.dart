import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import 'package:fluttertoast/fluttertoast.dart'
;
import 'package:intl/intl.dart' as intl;
import 'package:material_dialogs/dialogs.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../layout/cubit/cubit.dart';
import '../styles/colors.dart';
import 'Localization/Localization.dart';

import 'package:flutter/material.dart' as material;

///Default FormField Styling
Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType keyboard,
  required String label,
  required IconData prefix,
  required String? Function(String?)? validate,
  IconData? suffix,
  bool isObscure = false,
  bool isClickable = true,
  void Function(String)? onSubmit,
  void Function()? onPressedSuffixIcon,
  void Function()? onTap,
  void Function(String)? onChanged,
  void Function(String?)? onSaved,
  InputBorder? focusedBorderStyle,
  InputBorder? borderStyle,
  TextStyle? labelStyle,
  Color? prefixIconColor,
  Color? suffixIconColor,
  TextInputAction? inputAction,
  double borderRadius=8,
  double contentPadding=25,
  bool readOnly=false,
  int? digitsLimits,

  bool isFilled=false,
  Color? fillColor,
}) =>
    TextFormField(
      controller: controller,
      obscureText: isObscure,
      keyboardType: keyboard,
      onFieldSubmitted: onSubmit,
      textInputAction: inputAction,
      validator: validate,
      enabled: isClickable,
      readOnly: readOnly,
      onTap: onTap,
      onSaved: onSaved,
      onChanged: onChanged,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor,
        border:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        focusedBorder: focusedBorderStyle,
        enabledBorder: borderStyle,
        labelStyle: labelStyle,
        labelText: label,
        contentPadding: EdgeInsets.symmetric(vertical: contentPadding),
        prefixIcon: Icon(prefix, color: prefixIconColor,),
        suffixIcon: IconButton(
          onPressed: onPressedSuffixIcon,
          icon: Icon(
            suffix,
            color: suffixIconColor,
          ),
        ),
      ),
      inputFormatters:
      [
        LengthLimitingTextInputFormatter(digitsLimits),
      ],
    );


//--------------------------------------------------------------------------------------------------\\



//Default Boxes

///Default Box Styling
Widget defaultBox(
    {
      required AppCubit cubit,
      required boxColor,
      double borderRadius=8,
      double padding=25,
      bool paddingOptions=true,
      required Widget child,
      required void Function()? onTap,

      bool manualBorderColor=false,
      Color borderColor=Colors.white,

      double? containerWidth,

    })=>GestureDetector(

  onTap: onTap,
  child:  Container(

    padding: paddingOptions? EdgeInsetsDirectional.only(start: padding/1.5, end:padding, bottom:padding*1.2, top:padding/1.5) : EdgeInsetsDirectional.only(start: padding, end:padding, bottom:padding, top:padding) ,

    decoration: BoxDecoration(

      color: boxColor,

      borderRadius: BorderRadius.circular(borderRadius),

      border: Border.all(
          color: manualBorderColor ? borderColor : cubit.isDarkTheme? Colors.white : Colors.black
      ),

    ),

    width: containerWidth,

    child: child,


  ),
);


//------------------------------------------------------------------------------------------------------\\

///Default Button to be used
Widget defaultButton(
    {
      double letterSpacing=0,
      String title='Submit',
      AlignmentGeometry childAlignment=Alignment.center,
      double borderRadius=6,
      AlignmentGeometry gradientEndArea= Alignment.topRight,
      AlignmentGeometry gradientStartArea= Alignment.topLeft,
      required Color color,
      Color textColor=Colors.black,
      required void Function()? onTap,
      double width=185,
      String fontFamily = 'PT_Sans',

    })
{
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: childAlignment,
      width: width,
      height: 45,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        color: color,
      ),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: textColor,
          fontFamily: fontFamily,
          letterSpacing: letterSpacing,
        ),
      ),
    ),
  );
}


//-------------------------------------------------------------------------------------------------------\\


///DefaultToast message

//Return type was Future<bool?>
defaultToast({
  required String msg,
  ToastStates state=ToastStates.defaultType,
  ToastGravity position = ToastGravity.BOTTOM,
  Color color = Colors.grey,
  Color textColor= Colors.white,
  Toast length = Toast.LENGTH_SHORT,
  int time = 1,
})
{
  if(!kIsWeb)
    {
      return Fluttertoast.showToast(
        msg: msg,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: time,
        toastLength: length,
        backgroundColor: chooseToastColor(state),
        textColor: textColor,
      );
    }

  else
    {
      return EasyLoading.showToast(
        msg,
        toastPosition: EasyLoadingToastPosition.bottom,
        dismissOnTap: true,
        duration: const Duration(seconds: 3),
      );
      //return false;
    }
}

enum ToastStates{success,error,warning, defaultType}

Color chooseToastColor(ToastStates state) {
  switch (state)
  {
    case ToastStates.success:
      return Colors.green;
  // break;

    case ToastStates.error:
      return Colors.red;
  // break;

    case ToastStates.defaultType:
      return Colors.grey;

    case ToastStates.warning:
      return Colors.amber;
  // break;


  }
}

//--------------------------------------------------------------------------------------------------\\


/// Navigate to a screen, it takes context and a widget to go to.

void navigateTo( BuildContext context, Widget widget) =>Navigator.push(
  context,
  MaterialPageRoute(builder: (context)=>widget),

);

//--------------------------------------------------------------------------------------------------\\

/// Navigate to a screen and save the route name

void navigateAndSaveRouteSettings( BuildContext context, Widget widget, String routeName) =>Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context)=>widget,
    settings: RouteSettings(name: routeName,),
  ),

);

//--------------------------------------------------------------------------------------------------\\

/// Navigate to a screen and destroy the ability to go back
void navigateAndFinish(context,Widget widget) => Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context)=>widget),
      (route) => false,  // The Route that you came from, false will destroy the path back..
);

//--------------------------------------------------------------------------------------------------\\

///Default Divider for ListViews ...
Widget myDivider({Color? color=Colors.grey, double padding=0}) => Container(height: 1, width: double.infinity , color:color, padding: EdgeInsets.symmetric(horizontal: padding),);


//------------------------------------------------------------------------\\



///Convert a Color to MaterialColor

MaterialColor getMaterialColor(Color color) {
  final Map<int, Color> shades = {
    50:  const Color.fromRGBO(136, 14, 79, .1),
    100: const Color.fromRGBO(136, 14, 79, .2),
    200: const Color.fromRGBO(136, 14, 79, .3),
    300: const Color.fromRGBO(136, 14, 79, .4),
    400: const Color.fromRGBO(136, 14, 79, .5),
    500: const Color.fromRGBO(136, 14, 79, .6),
    600: const Color.fromRGBO(136, 14, 79, .7),
    700: const Color.fromRGBO(136, 14, 79, .8),
    800: const Color.fromRGBO(136, 14, 79, .9),
    900: const Color.fromRGBO(136, 14, 79, 1),
  };
  return MaterialColor(color.value, shades);
}

//---------------------------------------------------------------------------------\\

///Default Linear Loading Indicator

Widget defaultLinearProgressIndicator(BuildContext context, {double? value})
{
  return LinearProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultSecondaryDarkColor : defaultThirdColor,
    value: value,
  );
}

///Default Circular Loading Indicator
Widget defaultProgressIndicator(BuildContext context, {double? value})
{
  return CircularProgressIndicator(
    backgroundColor: AppCubit.get(context).isDarkTheme? defaultSecondaryDarkColor : defaultThirdColor,
    value: value,
  );
}


//---------------------------------------------------------------------------------------\\

///Check if a number is a numeric or not
isNumeric(string) => num.tryParse(string) != null;


//------------------------------------------------------------------------------------------\\

///Default Alert Dialogs

Widget defaultAlertDialog(
    {
      required BuildContext context,
      required String title,
      required Widget content,
    })
{
  return AlertDialog(
    title: Text(
      title,
      textAlign: TextAlign.center,
    ),

    content: content,

    elevation: 50,

    contentTextStyle: TextStyle(
        fontSize: 16,
        color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
        fontFamily: 'WithoutSans',
        fontWeight: FontWeight.w400
    ),

    titleTextStyle: TextStyle(
      fontSize: 22,
      color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
      fontWeight: FontWeight.w500,
      fontFamily: 'Neology',
    ),

    backgroundColor: AppCubit.get(context).isDarkTheme? defaultAlertDarkColor: defaultHomeColor,

    shape: Dialogs.dialogShape,
  );
}


//------------------------------------------------------------------------------------------\\

///Default AppBar

PreferredSizeWidget defaultAppBar({
  required AppCubit cubit,
  List<Widget>? actions,
})=>AppBar(

  title: Text(
    Localization.translate('appBar_title_home'),
    style: TextStyle(
      color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
      fontFamily: AppCubit.language=='ar'? 'Cairo' : 'Railway',
    ),
  ),

  actions:actions,


);




//------------------------------------------------------------------------------------------\\

///URL Launcher

Future<void> defaultLaunchUrl(String ur) async
{
  final Uri url = Uri.parse(ur);
  if (!await launchUrl(url))
  {
    throw 'Could not launch $url';
  }
}

//------------------------------------------------------------------------------------------\\

///Format Date to More readable one
String dateFormatter(String date)
{
  DateTime dateTime=DateTime.parse(date);

  intl.DateFormat format= intl.DateFormat('dd-MM-yyyy HH.mm');

  return format.format(dateTime);
}


//------------------------------------------------------------------------------------------\\

///Returns the directionality
TextDirection appDirectionality()
{
  return AppCubit.language=='ar' ? TextDirection.rtl : TextDirection.ltr;
}

//------------------------------------------------------------------------------------------\\

///Text Style builder

material.TextStyle textStyleBuilder({
  double fontSize=20,
  FontWeight fontWeight=FontWeight.normal,
  bool isTitle=false,
  Color? color,
  TextDecoration decoration = TextDecoration.none

})=>TextStyle(
  fontSize: fontSize,
  fontWeight: fontWeight,
  color:color ,
  decoration: decoration,
  fontFamily: isTitle?
  (AppCubit.language =='ar' ? 'Cairo' :'Railway' )
  :(AppCubit.language =='ar' ? 'Cairo' : 'PT_Sans'),

);


//------------------------------------------------------------------------------------------\\