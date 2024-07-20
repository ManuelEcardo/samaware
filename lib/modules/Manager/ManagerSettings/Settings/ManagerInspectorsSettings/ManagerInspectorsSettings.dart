import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/InspectorsDetailsModel/InspectorsDetailsModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerInspectorsSettings/InspectorDetailsPage.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerInspectorsSettings extends StatelessWidget {
  const ManagerInspectorsSettings({super.key});

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
              appBar: defaultAppBar(cubit: cubit, text: 'inspectors_settings_title'),

              body: Padding(
                padding: const EdgeInsets.all(24.0),

                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    physics: const BouncingScrollPhysics(),
                    dragDevices: dragDevices,
                  ),
                  child: RefreshIndicator(
                    onRefresh: ()async
                    {
                      cubit.inspectors=null;
                      cubit.getInspectors();
                    },
                    child: ConditionalBuilder(
                      condition: cubit.inspectors !=null,
                      builder: (context)=>OrientationBuilder(
                        builder: (context,orientation)
                        {
                          if(orientation == Orientation.portrait)
                          {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children:
                              [
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    Localization.translate('inspectors_details_settings_title'),
                                    style: headlineTextStyleBuilder(),
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, inspector: cubit.inspectors?.inspectors?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.inspectors!.inspectors!.length,
                                  ),
                                ),
                              ],
                            );
                          }
                          else
                          {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      Localization.translate('workers_details_settings_title'),
                                      style: headlineTextStyleBuilder(),
                                    ),
                                  ),

                                  const SizedBox(height: 25,),

                                  ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, inspector: cubit.inspectors?.inspectors?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.inspectors!.inspectors!.length,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),

                      fallback: (context)=> Center(child: defaultProgressIndicator(context)),
                    ),
                  ),
                ),
              ),
            ),
          );
        }
    );
  }

  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required InspectorDetailsModel? inspector})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        //Only get orders on click if it's empty, pagination happens by scroll in his page
        if(inspector?.orders?.length ==0)
        {
          cubit.getNextInspectorOrders(id: inspector!.inspector!.id!, nextPage: inspector.pagination?.nextPage);
        }

        navigateTo(context, InspectorDetailsPage(inspector: inspector!,));
      },
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text(
            '${inspector?.inspector?.name?? 'Worker Name'} ${inspector?.inspector?.lastName?? 'Worker Last'}',
            style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
