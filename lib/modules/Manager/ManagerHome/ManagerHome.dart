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
                                '${AppCubit.userData!.name!} ${AppCubit.userData!.lastName!} \n${Localization.translate(AppCubit.userData!.role!)}',
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
                                  '${AppCubit.userData!.name!} ${AppCubit.userData!.lastName!} \n${Localization.translate(AppCubit.userData!.role!)}',
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
