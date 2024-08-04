import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Collector/CollectorOrderDetails/CollectorOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class CollectorOrdersSettings extends StatefulWidget {
  const CollectorOrdersSettings({super.key});

  @override
  State<CollectorOrdersSettings> createState() => _CollectorOrdersSettingsState();
}

class _CollectorOrdersSettingsState extends State<CollectorOrdersSettings> {

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

              body: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(
                  physics: const BouncingScrollPhysics(),
                  dragDevices: dragDevices,
                ),
                child: RefreshIndicator(
                  onRefresh: ()async
                  {
                    cubit.allCollectorOrders=null;
                    cubit.getAllCollectorOrders();
                    defaultToast(msg: Localization.translate('getting_all_orders_toast'));
                  },
                  child: ConditionalBuilder(

                    condition: cubit.allCollectorOrders !=null,

                    builder: (context)=>OrientationBuilder(
                        builder: (context,orientation)
                        {
                          if(orientation == Orientation.portrait)
                          {
                            return Padding(
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
                                      key:_key,
                                      controller: scrollController,
                                      shrinkWrap: true,
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.allCollectorOrders?.orders?[index]),
                                      separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                      itemCount: cubit.allCollectorOrders!.orders!.length,
                                    ),
                                  ),

                                  if(state is AppGetNextCollectorOrdersCLoadingState && cubit.allCollectorOrders?.orders?.length !=0)
                                    defaultLinearProgressIndicator(context),
                                ],
                              ),
                            );
                          }

                          else
                          {
                            return SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              key:_key,
                              controller: scrollController,
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
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: cubit.allCollectorOrders?.orders?[index]),
                                      separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                      itemCount: cubit.allCollectorOrders!.orders!.length,
                                    ),

                                    if(state is AppGetNextCollectorOrdersCLoadingState && cubit.allCollectorOrders?.orders?.length !=0)
                                      defaultLinearProgressIndicator(context),
                                  ],
                                ),
                              ),
                            );
                          }
                        }
                    ),

                    fallback: (context)=> Center(child: defaultProgressIndicator(context),),
                  ),
                ),
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
        navigateTo(context, CollectorOrderDetails(order: order!));
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
      if(cubit.allCollectorOrders?.pagination?.nextPage !=null)
      {
        print('paginating next collector orders...');
        cubit.getNextWorkerOrdersCollector( nextPage: cubit.allCollectorOrders?.pagination?.nextPage);
      }

    }
  }
}
