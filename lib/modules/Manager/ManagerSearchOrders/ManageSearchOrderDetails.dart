import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:string_extensions/string_extensions.dart';

class ManageSearchOrderDetails extends StatelessWidget {
  const ManageSearchOrderDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppStates>(
      listener: (context,state){},
      
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        
        return PopScope(
          canPop: true,
          onPopInvoked: (pop)
          {
            cubit.searchOrders=null;
          },
          child: Directionality(
              textDirection: appDirectionality(),
              child: Scaffold(
                appBar: AppBar(),

                body: ConditionalBuilder(
                  condition: cubit.searchOrders !=null,
                  builder: (context)=>Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: OrientationBuilder(
                      builder: (context, orientation)
                      {
                        if(orientation == Orientation.portrait)
                        {
                          return Column(
                            children:
                            [
                              Align(
                                alignment: AlignmentDirectional.center,
                                child: Text(
                                  Localization.translate('search_results_title'),
                                  style: headlineTextStyleBuilder(),
                                ),
                              ),

                              const SizedBox(height: 25,),

                              myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor: defaultThirdColor),

                              const SizedBox(height: 25,),

                              if(cubit.searchOrders!.orders!.isEmpty)
                                Center(child: Text(Localization.translate('no_available_results'), style: textStyleBuilder(),),),

                              Expanded(
                                child: ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.searchOrders?.orders?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.searchOrders!.orders!.length,
                                ),
                              )
                            ],
                          );
                        }

                        else
                        {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              children:
                              [
                                Align(
                                  alignment: AlignmentDirectional.center,
                                  child: Text(
                                    Localization.translate('search_results_title'),
                                    style: headlineTextStyleBuilder(),
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor: defaultThirdColor),

                                const SizedBox(height: 25,),

                                if(cubit.searchOrders!.orders!.isEmpty)
                                  Center(child: Text(Localization.translate('no_available_results'), style: textStyleBuilder(),),),

                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.searchOrders?.orders?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.searchOrders!.orders!.length,
                                )
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  ),

                  fallback: (context)=>Center(child: defaultProgressIndicator(context),),
                ),
              ),
          ),
        );
      },
    );
  }

  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required OrderModel? order})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        navigateTo(context, ManagerOrderDetails(order: order!));
      },
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:
        [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Text(
                order?.orderId ?? 'order ID',
                style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
              ),

              const SizedBox(width: 10,),

              Text(
                '|',
                style: textStyleBuilder(fontSize: 24, fontWeight: FontWeight.w700),
              ),

              const SizedBox(width: 10,),

              Text(
                '${order?.worker?.name.capitalize?? 'Worker Name'} ${order?.worker?.lastName.capitalize?? 'Worker Last'}',
                style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ],
          ),

          const SizedBox(height: 5,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
            [
              Text(
                translateWord(order?.status?? 'order_state'),
                style: textStyleBuilder(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
