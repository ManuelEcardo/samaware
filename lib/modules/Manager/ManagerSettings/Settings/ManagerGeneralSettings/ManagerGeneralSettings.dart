import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/shared/components/Localization/Localization.dart';
import 'package:samaware_flutter/shared/components/components.dart';
import 'package:samaware_flutter/shared/network/local/cache_helper.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerGeneralSettings extends StatefulWidget {
  const ManagerGeneralSettings({super.key});

  @override
  State<ManagerGeneralSettings> createState() => _ManagerGeneralSettingsState();
}

class _ManagerGeneralSettingsState extends State<ManagerGeneralSettings>
{
  List<String> listOfLanguages = ['ar','en'];

  String currentLanguage= AppCubit.language??='en';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: defaultAppBar(cubit: cubit, text: 'general_settings_title'),
            body: SingleChildScrollView(
              child: Directionality(
                textDirection: appDirectionality(),

                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children:
                      [
                        Row(
                          children:
                          [
                            const Icon(
                              Icons.language,
                              size: 22,
                            ),

                            const SizedBox(width: 10,),

                            Expanded(
                              child: Text(
                                Localization.translate('language_name_general_settings'),
                                maxLines: 1,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    overflow: TextOverflow.ellipsis
                                ),
                              ),
                            ),

                            //const Spacer(),

                            Expanded(
                              child: FormField<String>(
                                builder: (FormFieldState<String> state) {
                                  return InputDecorator(
                                    decoration: InputDecoration(
                                      enabledBorder: InputBorder.none,
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      errorStyle:const TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                      labelText: Localization.translate('language_name_general_settings'),
                                    ),

                                    child: DropdownButtonHideUnderline(
                                      child: DropdownButton<String>(
                                        style: TextStyle(
                                            color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                            fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                        ),
                                        value: currentLanguage,
                                        isDense: true,
                                        onChanged: (newValue) {
                                          setState(() {
                                            print('Current Language is: $newValue');
                                            currentLanguage = newValue!;
                                            state.didChange(newValue);

                                            CacheHelper.saveData(key: 'language', value: newValue).then((value){

                                              //defaultToast(msg: 'App Will Restart Now to take effect');
                                              cubit.changeLanguage(newValue);
                                              Localization.load(Locale(newValue));

                                              // Timer(const Duration(seconds: 2), ()
                                              // {
                                              //   PhoenixNative.restartApp();
                                              // });

                                            }).catchError((error)
                                            {
                                              print('ERROR WHILE SWITCHING LANGUAGES, ${error.toString()}');
                                              defaultToast(msg: error.toString());
                                            });


                                          });
                                        },
                                        items: listOfLanguages.map((String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Row(
                                              children: [
                                                Text(
                                                  value == 'ar' ? Localization.translate('arabic_general_settings') : Localization.translate('english_general_settings'),
                                                  overflow: TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                ),
                                              ],
                                            ),
                                          );
                                        }).toList(),


                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),

                          ],
                        ),

                        const SizedBox(height: 20,),

                        Row(
                          children:
                          [
                            Icon(
                              cubit.isDarkTheme? Icons.sunny : Icons.brightness_3_rounded,
                              size: 22,
                            ),

                            const SizedBox(width: 10,),

                            Text(
                              Localization.translate('dark_mode_appearance'),
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500
                              ),
                            ),

                            const Spacer(),

                            Switch(
                              value: cubit.isDarkTheme,
                              onChanged: (bool newValue)
                              {
                                cubit.changeTheme();
                              },
                              activeColor: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                              inactiveTrackColor: cubit.isDarkTheme? Colors.white: null,
                              activeTrackColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.5) : defaultColor.withOpacity(0.5),
                            ),
                          ],
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },

    );
  }
}
