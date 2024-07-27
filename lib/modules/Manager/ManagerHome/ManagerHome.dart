import 'package:samaware_flutter/modules/Manager/ManagerCreateOrder/ManagerCreateOrder.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:string_extensions/string_extensions.dart';

class ManagerHome extends StatelessWidget {
  const ManagerHome({super.key});

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
            builder: (context, orientation)
            {
              if(orientation == Orientation.portrait)
                {
                  return Padding(
                      padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0 ),
                    child: Column(
                      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                        Row(
                          children:
                          [
                            const Expanded(
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage('assets/images/profile/maleFigure.jpg'),
                                    radius: 55,

                                  ),
                                ],
                              ),
                            ),


                            Expanded(
                              child: Text(
                                '${AppCubit.userData!.name!.capitalize} ${AppCubit.userData!.lastName!.capitalize} \n${Localization.translate(AppCubit.userData!.role!)}',
                                style: textStyleBuilder(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  isTitle: true,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 15,),

                        Padding(
                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
                          child: myDivider(color: defaultCanvasDarkColor),
                        ),

                        const SizedBox(height: 50,),

                        Padding(
                          padding: const EdgeInsetsDirectional.only(start: 24.0),
                          child: Row(
                            children:
                            [
                              Text(
                                Localization.translate('add_new_order'),
                                style: textStyleBuilder(
                                  isTitle: true,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,

                                ),
                              ),


                              const Spacer(),

                              TextButton(
                                onPressed: ()
                                {
                                  navigateTo(context, const ManagerCreateOrder());
                                },
                                child: Text(
                                  Localization.translate('add_new_order_now'),
                                  style: textStyleBuilder(
                                    decoration: TextDecoration.underline,
                                    isTitle: true
                                  ),
                                ),
                              ),

                              const Spacer(),
                            ],
                          ),
                        ),

                      ],
                    ),
                  );
                }

              else
                {
                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0),
                      child: Column(
                        children:
                        [
                          Row(
                            children:
                            [
                              const Expanded(
                                child: Column(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: AssetImage('assets/images/profile/maleFigure.jpg'),
                                      radius: 55,

                                    ),
                                  ],
                                ),
                              ),


                              Expanded(
                                child: Text(
                                  '${AppCubit.userData!.name!.capitalize} ${AppCubit.userData!.lastName!.capitalize} \n${Localization.translate(AppCubit.userData!.role!)}',
                                  style: textStyleBuilder(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    isTitle: true,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15,),

                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
                            child: myDivider(color: defaultCanvasDarkColor),
                          ),

                          const SizedBox(height: 50,),

                          Padding(
                            padding: const EdgeInsetsDirectional.only(start: 24.0),
                            child: Row(
                              children:
                              [
                                Text(
                                  Localization.translate('add_new_order'),
                                  style: textStyleBuilder(
                                    isTitle: true,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24,
                                    color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,

                                  ),
                                ),


                                const Spacer(),

                                TextButton(
                                  onPressed: ()
                                  {
                                    navigateTo(context, const ManagerCreateOrder());
                                  },
                                  child: Text(
                                    Localization.translate('add_new_order_now'),
                                    style: textStyleBuilder(
                                        decoration: TextDecoration.underline,
                                        isTitle: true
                                    ),
                                  ),
                                ),

                                const Spacer(),
                              ],
                            ),
                          ),

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
}
