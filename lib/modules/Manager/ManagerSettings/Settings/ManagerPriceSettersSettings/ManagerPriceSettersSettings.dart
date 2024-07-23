import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/PriceSettersDetailsModel/PriceSettersDetailsModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerPriceSettersSettings/PriceSetterDetailsPage.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerPriceSettersSettings extends StatelessWidget {
  const ManagerPriceSettersSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {
          if(state is AppGetPriceSettersLoadingState)
          {
            defaultToast(msg: Localization.translate('get_priceSetters_details_toast'));
          }
        },
        builder: (context,state)
        {
          var cubit= AppCubit.get(context);

          return Directionality(

            textDirection: appDirectionality(),
            child: Scaffold(
              appBar: defaultAppBar(cubit: cubit, text: 'priceSetters_settings_title'),

              body: ConditionalBuilder(
                condition: cubit.priceSetters !=null,
                builder: (context)=>Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: ScrollConfiguration(
                    behavior: ScrollConfiguration.of(context).copyWith(
                      physics: const BouncingScrollPhysics(),
                      dragDevices: dragDevices,
                    ),
                    child: RefreshIndicator(
                      onRefresh: ()async
                      {
                        cubit.priceSetters=null;
                        cubit.getPriceSetters();
                      },
                      child: OrientationBuilder(
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
                                    Localization.translate('priceSetters_details_settings_title'),
                                    style: headlineTextStyleBuilder(),
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                Expanded(
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, priceSetter: cubit.priceSetters?.priceSetters?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.priceSetters!.priceSetters!.length,
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
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, priceSetter: cubit.priceSetters?.priceSetters?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.priceSetters!.priceSetters!.length,
                                  ),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                fallback: (context)=>Center(child: defaultProgressIndicator(context)),
              ),
            ),
          );
        }
    );
  }

  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required PriceSetterDetailsModel? priceSetter})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        //Only get orders on click if it's empty, pagination happens by scroll in his page
        if(priceSetter?.orders?.length ==0)
        {
          cubit.getNextPriceSetterOrdersManager(id: priceSetter!.priceSetter!.id!, nextPage: priceSetter.pagination?.nextPage);
        }

        navigateTo(context, PriceSetterDetailsPage(priceSetter: priceSetter!,));
      },
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text(
            '${priceSetter?.priceSetter?.name?? 'Worker Name'} ${priceSetter?.priceSetter?.lastName?? 'Worker Last'}',
            style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
