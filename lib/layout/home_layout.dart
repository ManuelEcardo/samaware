import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/components/Localization/Localization.dart';
import '../shared/components/components.dart';
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

        return Directionality(
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

                body: Center(child: defaultProgressIndicator(context),),
              ),
            ),
        );
      }
    );
  }
}
