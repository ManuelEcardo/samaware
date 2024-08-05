import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerAddNewClientsSettings extends StatelessWidget {
  const ManagerAddNewClientsSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},

      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        
        return Directionality(
            textDirection: appDirectionality(),
            child: Scaffold(
              appBar: defaultAppBar(
                text: Localization.translate('add_new_items_title'),
                cubit: cubit,
              ),

              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: OrientationBuilder(
                  builder: (context,orientation)
                  {
                    if(orientation == Orientation.portrait)
                    {
                      return SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          mainAxisSize: MainAxisSize.min,
                          children:
                          [
                            Text(
                              Localization.translate('import_new_clients_title'),

                              style: headlineTextStyleBuilder(),
                            ),

                            const SizedBox(height: 25,),

                            Align(
                              alignment: AlignmentDirectional.center,
                              child: TextButton(
                                onPressed: ()
                                {
                                  pickFile().then((value)
                                  {
                                    if(value!=null)
                                    {
                                      //ToDo Import excel file then get Clients
                                    }

                                  }).catchError((error, stackTrace)
                                  {
                                    print('${Localization.translate('error_importing_file')}, ${error.toString()}');
                                    print(stackTrace);
                                  });
                                },
                                child: Text(
                                  Localization.translate('import_excel'),

                                  style: textStyleBuilder(
                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                    fontSize: 22,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    else
                    {
                      return Column();
                    }
                  },
                ),
              ),
            ),
        );
      },
    );
  }
}
