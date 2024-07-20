import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Localization/Localization.dart';
import 'package:samaware_flutter/shared/components/components.dart';
import 'package:samaware_flutter/shared/components/constants.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';
import 'package:string_extensions/string_extensions.dart';

class ManagerOrdersSettings extends StatefulWidget {
  const ManagerOrdersSettings({super.key});

  @override
  State<ManagerOrdersSettings> createState() => _ManagerOrdersSettingsState();
}

class _ManagerOrdersSettingsState extends State<ManagerOrdersSettings> {

  //Scroll Controller & listener for Lazy Loading
  ScrollController scrollController= ScrollController();
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    AppCubit cubit= AppCubit.get(context);

    scrollController.addListener(()
    {
      _onScroll(cubit);
    });
  }

  @override
  void dispose()
  {
    scrollController.dispose();
    super.dispose();
  }

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
              appBar: defaultAppBar(cubit: cubit, text: 'orders_settings_title'),

              body: ConditionalBuilder(
                condition: cubit.allOrders !=null,

                builder: (context)=>OrientationBuilder(
                  builder: (context,orientation)
                  {
                    if(orientation == Orientation.portrait)
                    {
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          physics: const BouncingScrollPhysics(),
                          dragDevices: dragDevices,
                        ),
                        child: RefreshIndicator(
                          onRefresh: ()async
                          {
                            cubit.getAllOrders();
                            defaultToast(msg: Localization.translate('getting_all_orders_toast'));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    Localization.translate('orders_details_settings_title'),
                                    style: headlineTextStyleBuilder(),
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                Expanded(
                                  child: ListView.separated(
                                    physics: const AlwaysScrollableScrollPhysics(),
                                    key: _key,
                                    controller: scrollController,
                                    shrinkWrap: true,
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.allOrders?.orders?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.allOrders!.orders!.length,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }

                    else
                    {
                      return ScrollConfiguration(
                        behavior: ScrollConfiguration.of(context).copyWith(
                          physics: const BouncingScrollPhysics(),
                          dragDevices: dragDevices,
                        ),
                        child: RefreshIndicator(
                          onRefresh: ()async
                          {
                            cubit.getAllOrders();
                            defaultToast(msg: Localization.translate('getting_all_orders_toast'));
                          },
                          child: SingleChildScrollView(
                            key: _key,
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                  Align(
                                    alignment: AlignmentDirectional.topStart,
                                    child: Text(
                                      Localization.translate('orders_details_settings_title'),
                                      style: headlineTextStyleBuilder(),
                                    ),
                                  ),

                                  const SizedBox(height: 25,),

                                  ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.allOrders?.orders?[index]),
                                    separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                    itemCount: cubit.allOrders!.orders!.length,
                                  ),

                                  if(state is AppGetNextOrdersLoadingState)
                                    defaultLinearProgressIndicator(context),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }
                  }
                ),

                fallback: (context)=> Center(child: defaultProgressIndicator(context),),
              ),
            ),
          );
        }
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

  ///onScroll Function for to get orders
  void _onScroll(AppCubit cubit)
  {
    //Will Scroll Only and Only if: Got to the end of the list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
    {
      if(cubit.allOrders?.pagination?.nextPage !=null)
      {
        print('paginating next orders...');
        cubit.getNextOrders(nextPage: cubit.allOrders?.pagination?.nextPage);
      }

    }
  }
}
