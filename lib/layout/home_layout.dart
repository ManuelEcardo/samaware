import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/Localization/Localization.dart';
import '../shared/components/components.dart';
import '../shared/components/constants.dart';
import 'cubit/cubit.dart';
import 'cubit/states.dart';

class HomeLayout extends StatefulWidget {
  const HomeLayout({super.key});

  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}


class _HomeLayoutState extends State<HomeLayout> {

  @override
  void initState()
  {
    super.initState();
    AppCubit cu= AppCubit.get(context);
    cu.alterBottomNavBarItems(AppCubit.userData?.role);
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit = AppCubit.get(context);

        return PopScope(
          canPop: false,
          onPopInvoked: (didPop)
          {
            showDialog(
                context: context,
                builder: (dialogContext)
                {
                  return defaultAlertDialog(
                    context: dialogContext,
                    title: Localization.translate('logout_profile'),
                    content: SingleChildScrollView(
                        child: Column(
                          children:
                          [
                            Text(
                              Localization.translate('logout_secondary_title'),
                              style: textStyleBuilder(),
                            ),

                            const SizedBox(height: 5,),

                            Row(
                              children:
                              [
                                TextButton(
                                    onPressed: ()
                                    {
                                      exit(0);
                                    },
                                    child: Text(Localization.translate('exit_app_yes'), style: textStyleBuilder(),)
                                ),

                                const Spacer(),

                                TextButton(
                                  onPressed: ()
                                  {
                                    Navigator.of(dialogContext).pop(false);
                                  },
                                  child: Text(Localization.translate('exit_app_no'), style: textStyleBuilder()),
                                ),
                              ],
                            ),
                          ],
                        )
                    ),
                  );
                }
            );
          },

          child: Directionality(
              textDirection: appDirectionality(),
              child: ConditionalBuilder(
                condition: AppCubit.userData !=null,

                builder: (BuildContext context)
                {
                  return Scaffold(
                    appBar: defaultAppBar(
                      cubit: cubit,
                      actions:
                      [],
                    ),

                    body: cubit.bottomBarWidgets[cubit.currentBottomBarIndex],

                    bottomNavigationBar: BottomNavigationBar(
                      currentIndex: cubit.currentBottomBarIndex,

                      onTap: (index)
                      {
                        const Duration(milliseconds: 800);
                        cubit.changeBottomNavBar(index);
                      },

                      items:
                      [
                        BottomNavigationBarItem(label: Localization.translate('home_bnb'), icon: const Icon(Icons.home)),

                        BottomNavigationBarItem(label: Localization.translate('orders_bnb') , icon: const Icon(Icons.list_alt_outlined)),

                        BottomNavigationBarItem(label: Localization.translate('settings_bnb') ,icon: const Icon(Icons.settings_outlined)),
                      ],

                    ),

                    resizeToAvoidBottomInset: false, //For Text File Page when adding text => won't resize itself
                  );
                },

                fallback: (BuildContext context)=> Scaffold(
                  appBar: defaultAppBar(cubit: cubit),

                  body: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      physics: const BouncingScrollPhysics(),
                      dragDevices: dragDevices,
                    ),
                    child: RefreshIndicator(
                        onRefresh: ()async
                        {
                          cubit.getMyAPI(getAll: true, getUseData: true);
                        },
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(height: MediaQuery.of(context).size.height /2.5,),

                                defaultProgressIndicator(context),
                              ],
                            ),
                          )
                        )
                    ),
                  ),
                ),
              ),
          ),
        );
      }
    );
  }
}
