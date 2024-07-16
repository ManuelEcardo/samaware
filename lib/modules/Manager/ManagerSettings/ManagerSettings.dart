import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerGeneralSettings/ManagerGeneralSettings.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerOrdersSettings/ManagerOrdersSettings.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerWorkersSettings/ManagerWorkersSettings.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

import '../../../shared/network/local/cache_helper.dart';
import '../../../shared/styles/colors.dart';

class ManagerSettings extends StatefulWidget {
  const ManagerSettings({super.key});

  @override
  State<ManagerSettings> createState() => _ManagerSettingsState();
}

class _ManagerSettingsState extends State<ManagerSettings> {

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return Directionality(
          textDirection: appDirectionality(),

          child: OrientationBuilder(
            builder: (context,orientation)
            {
              if(orientation == Orientation.portrait)
              {
                return Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,

                    children:
                    [
                      defaultBox(
                          padding: 15,
                          paddingOptions: false,
                          cubit: cubit,
                          boxColor: null, //cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                          child: Column(
                            children:
                            [
                              itemBuilder(
                                  icon: Icons.settings_outlined,
                                  cubit: cubit,
                                  text: Localization.translate('general_settings_title'),
                                  onTap: ()
                                  {
                                    navigateTo(context, const ManagerGeneralSettings());
                                  }
                              ),

                              const SizedBox(height: 10),

                              myDivider(color: Colors.white),

                              itemBuilder(
                                  icon: Icons.person_outline_rounded,
                                  cubit: cubit,
                                  text: Localization.translate('workers_settings_title'),
                                  onTap: ()
                                  {
                                    navigateTo(context, const ManagerWorkersSettings());
                                  }
                              ),

                              const SizedBox(height: 10),

                              myDivider(color: Colors.white),

                              itemBuilder(
                                  icon: Icons.reorder,
                                  cubit: cubit,
                                  text: Localization.translate('orders_settings_title'),
                                  onTap: ()
                                  {
                                    if(cubit.allOrders==null)
                                    {
                                      print('getting all orders after press from settings...');
                                      cubit.getAllOrders();
                                    }

                                    navigateTo(context, const ManagerOrdersSettings());
                                  }
                              ),
                            ],
                          ),
                          onTap: (){},
                          manualBorderColor: true,
                          borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                      ),

                      const SizedBox(height: 20,),

                      defaultBox(
                          padding: 15,
                          paddingOptions: false,
                          cubit: cubit,
                          boxColor: null, //cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                          child: Column(
                            children:
                            [
                              itemBuilder(
                                  icon: Icons.logout_outlined,
                                  cubit: cubit,
                                  text: Localization.translate('logout_profile'),
                                  onTap: ()
                                  {
                                    //cubit.logout(context: context, role: AppCubit.userData!.role!);


                                    showDialog(
                                      context: context,
                                      builder: (dialogContext)
                                      {
                                        return defaultAlertDialog(
                                          context: dialogContext,
                                          title: Localization.translate('logout_profile'),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children:
                                              [
                                                Text(Localization.translate('logout_secondary_title')),

                                                const SizedBox(height: 5,),

                                                Row(
                                                  children:
                                                  [
                                                    TextButton(
                                                        onPressed: ()=> cubit.logout(context: context, role: AppCubit.userData!.role!), //Navigator.of(context).pop(true),
                                                        child: Text(Localization.translate('exit_app_yes'))
                                                    ),

                                                    const Spacer(),

                                                    TextButton(
                                                      onPressed: ()=> Navigator.of(dialogContext).pop(false),
                                                      child: Text(Localization.translate('exit_app_no')),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }
                                    );
                                  }
                              ),

                            ],
                          ),
                          onTap: (){},
                          manualBorderColor: true,
                          borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                      ),

                    ],
                  ),
                );
              }
              else
              {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,

                      children:
                      [
                        defaultBox(
                            padding: 15,
                            paddingOptions: false,
                            cubit: cubit,
                            boxColor: null, //cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            child: Column(
                              children:
                              [
                                itemBuilder(
                                    icon: Icons.settings_outlined,
                                    cubit: cubit,
                                    text: Localization.translate('general_settings_title'),
                                    onTap: ()
                                    {
                                      navigateTo(context, const ManagerGeneralSettings());
                                    }
                                ),

                                const SizedBox(height: 10),

                                myDivider(color: Colors.white),

                                itemBuilder(
                                    icon: Icons.person_outline_rounded,
                                    cubit: cubit,
                                    text: Localization.translate('workers_settings_title'),
                                    onTap: ()
                                    {
                                      navigateTo(context, const ManagerWorkersSettings());
                                    }
                                ),

                                const SizedBox(height: 10),

                                myDivider(color: Colors.white),

                                itemBuilder(
                                    icon: Icons.reorder,
                                    cubit: cubit,
                                    text: Localization.translate('orders_settings_title'),
                                    onTap: ()
                                    {
                                      navigateTo(context, const ManagerOrdersSettings());
                                    }
                                ),
                              ],
                            ),
                            onTap: (){},
                            manualBorderColor: true,
                            borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                        ),

                        const SizedBox(height: 20,),

                      ],
                    ),
                  ),
                );
              }
            },
          ),
        );
      },

    );
  }

  //Default item builder for each page
  Widget itemBuilder({required IconData icon, required String text, required void Function()? onTap, required AppCubit cubit}) => GestureDetector(

    onTap: onTap,

    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children:
      [
        Icon(icon),

        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(start: 15.0),
            child: Text(
              text,
              style: textStyleBuilder(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),

        //const Spacer(),

        Align(
          alignment: AlignmentDirectional.topEnd,
          child: IconButton(
            onPressed: onTap,
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
            ),
            iconSize: 20,
          ),
        ),
      ],
    ),
  );
}
