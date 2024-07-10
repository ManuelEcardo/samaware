import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';
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
                              child: CircleAvatar(
                                backgroundImage: AssetImage('assets/images/profile/maleFigure.jpg'),
                                radius: 50,
                              ),
                            ),


                            Expanded(
                              child: Text(
                                '${AppCubit.userData!.name!.capitalize} ${AppCubit.userData!.lastName!.capitalize} \n${Localization.translate(AppCubit.userData!.role!)}',
                                style: textStyleBuilder(
                                  fontSize: 24,
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
                          child: myDivider(color: defaultDarkFontColor),
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


                              TextButton(
                                onPressed: ()
                                {

                                },
                                child: Text(
                                  'Add Now!',
                                  style: textStyleBuilder(
                                    decoration: TextDecoration.underline
                                  ),
                                ),
                              ),

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
                                child: CircleAvatar(
                                  backgroundImage: AssetImage('assets/images/profile/maleFigure.jpg'),
                                  radius: 50,
                                ),
                              ),


                              Expanded(
                                child: Text(
                                  '${AppCubit.userData!.name!.capitalize} ${AppCubit.userData!.lastName!.capitalize} \n${Localization.translate(AppCubit.userData!.role!)}',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: AppCubit.language =='ar'? 'Cairo' : 'Railway'
                                  ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 15,),

                          Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 18.0),
                            child: myDivider(color: defaultDarkFontColor),
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
