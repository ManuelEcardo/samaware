import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/NewClientsModel/NewClientsModel.dart';
import 'package:samaware_flutter/models/SalesmenModel/SalesmenModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerGeneralSettings/AddClients/ManagerAlterNewClientsSettings.dart';
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
        var clients= cubit.newClients;

        return PopScope(
          child: Directionality(
              textDirection: appDirectionality(),
              child: Scaffold(
                appBar: defaultAppBar(
                  text: Localization.translate('add_new_clients_title'),
                  cubit: cubit,
                ),

                body: Padding(
                  padding: const EdgeInsets.all(24.0),

                  child: OrientationBuilder(
                    builder: (context,orientation)
                    {
                      if(orientation == Orientation.portrait)
                      {
                        return ConditionalBuilder(
                          condition: cubit.excelClientsFile !=null,

                          builder: (context)=>Column(
                            //crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  Localization.translate('new_clients_added_title'),

                                  style: headlineTextStyleBuilder(),
                                ),
                              ),
                              const SizedBox(height: 25,),
                              myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),

                              const SizedBox(height: 25,),

                              Expanded(
                                  child: ListView.separated(
                                      physics: const AlwaysScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, client: clients[index], clientIndex: index),
                                      separatorBuilder: (context,index)=>const SizedBox(height: 20,),
                                      itemCount: clients.length,
                                  )
                              ),

                              const SizedBox(height: 20,),

                              Center(
                                child: defaultButton(
                                  title: Localization.translate('submit_button'),
                                  color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                  onTap: ()
                                  {
                                    //ToDo perform submit
                                    //This was written for if the user didn't choose a worker=> it will stay the number one but it won't be set at the orderFromExcel since it wasn't created yet
                                    // cubit.setChosenWorker(w:cubit.chosenWorker);
                                    //
                                    // cubit.createOrder(cubit.orderFromExcel, context);
                                  },
                                ),
                              ),
                            ],
                          ),

                          fallback: (context)=> SingleChildScrollView(
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

                                          cubit.setClientsExcelFile(value);
                                          cubit.readClientsFileAndExtractData(value);
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
                          ),
                        );
                      }

                      else
                      {
                        //Todo Do The landscape for addNewClients
                        return Column();
                      }
                    },
                  ),
                ),
              ),
          ),

          onPopInvoked: (pop)
          {
            //Todo remove commenting
            // cubit.excelClientsFile=null;
            // cubit.newClients=[];
          },
        );
      },
    );
  }

  ///Item builder for client details...
  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required NewClientsModel? client, required int clientIndex})
  {
    SalesmanModel? salesman = cubit.findSalesmanById(client!.salesmanId!);

    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:
        [
          Stack(
            alignment: AlignmentDirectional.topEnd,
            fit: StackFit.passthrough,
            clipBehavior: Clip.antiAlias,

            children: [
              Align(
                alignment: AlignmentDirectional.topStart,
                child: Text(
                  client.clientName ?? 'CLIENT NAME?',
                  style: textStyleBuilder(),
                ),
              ),

              InkWell(
                highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                onTap: ()
                {
                  if(salesman !=null )navigateTo(context, ManagerAlterNewClientsSettings(client: client, salesman: salesman, clientIndex: clientIndex,));
                },
                child: const Icon(Icons.edit)
              ),

            ],
          ),

          const SizedBox(height: 10,),

          Text(
            '${Localization.translate('salesman_secondary')} ${translateWord(salesman?.name?? 'SALESMAN??')}',
            style: textStyleBuilder(),
          ),

          const SizedBox(height: 10,),

          Text(
            '${Localization.translate('location_secondary')} ${client.location}',
            style: textStyleBuilder(),
          ),
        ],
      ),
    );
  }
}
