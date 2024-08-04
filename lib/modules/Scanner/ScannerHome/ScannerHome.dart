import 'dart:async';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Scanner/ScannerPrepareOrder/ScannerPrepareOrder.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:string_extensions/string_extensions.dart';

class ScannerHome extends StatefulWidget {
  const ScannerHome({super.key});

  @override
  State<ScannerHome> createState() => _ScannerHomeState();
}

class _ScannerHomeState extends State<ScannerHome> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Update every minute
    _timer = Timer.periodic(const Duration(minutes: 1), (Timer t)
    {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        var orders = cubit.scannerWaitingOrders;
        return Directionality(
          textDirection: appDirectionality(),
          child: OrientationBuilder(
            builder: (context, orientation)
            {
              if(orientation==Orientation.portrait)
              {
                return ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    physics: const BouncingScrollPhysics(),
                    dragDevices: dragDevices,
                  ),
                  child: RefreshIndicator(
                    onRefresh: ()async
                    {
                      cubit.getWaitingOrdersScanner();
                      defaultToast(msg: Localization.translate('getting_waiting_orders_toast'));
                    },
                    child: Padding(
                      padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0 ),
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
                            child: Align(
                              alignment: AlignmentDirectional.topStart,
                              child: Text(
                                Localization.translate('available_orders_worker'),
                                style: textStyleBuilder(
                                  isTitle: true,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 24,
                                  color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,

                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30,),

                          if(orders!=null && orders.orders!.isEmpty)
                            Text(
                              Localization.translate('no_available_orders'),
                              style: textStyleBuilder(),
                            ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsetsDirectional.only(start: 24.0),
                              child: ConditionalBuilder(
                                condition: orders!=null,
                                builder: (context)=>ListView.separated(
                                    shrinkWrap:true,
                                    itemBuilder: (context,index)
                                    {
                                      return defaultBox(
                                          padding: 15,
                                          paddingOptions: false,
                                          cubit: cubit,
                                          boxColor: null, //cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                          child: itemBuilder(index: index, order: orders.orders![index]),
                                          onTap: ()
                                          {
                                            cubit.setInWorkingOrder(orders.orders?[index]);

                                            navigateTo(context, ScannerPrepareOrder(orderId:  orders.orders![index].orderId!,));
                                          },
                                          manualBorderColor: true,
                                          borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                                      );
                                    },

                                    separatorBuilder: (context,index)=>const SizedBox(height: 30),

                                    itemCount: orders!.orders!.length
                                ),

                                fallback: (context)=>Center(child: defaultProgressIndicator(context)),
                              ),
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
                      cubit.getWaitingOrdersScanner();
                      defaultToast(msg: Localization.translate('getting_waiting_orders_toast'));
                    },

                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.only(top:24.0, bottom: 24.0, end: 24.0 ),
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
                              child: Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  Localization.translate('available_orders_worker'),
                                  style: textStyleBuilder(
                                    isTitle: true,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 24,
                                    color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,

                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 30,),

                            if(orders!=null && orders.orders!.isEmpty)
                              Text(
                                Localization.translate('no_available_orders'),
                                style: textStyleBuilder(),
                              ),

                            Padding(
                              padding: const EdgeInsetsDirectional.only(start: 24.0),
                              child: ConditionalBuilder(
                                condition: orders!=null,
                                builder: (context)=>ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap:true,
                                    itemBuilder: (context,index)
                                    {
                                      return defaultBox(
                                          padding: 15,
                                          paddingOptions: false,
                                          cubit: cubit,
                                          boxColor: null, //cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                          child: itemBuilder(index: index, order: orders.orders![index]),
                                          onTap: ()
                                          {
                                            cubit.setInWorkingOrder(orders.orders?[index]);


                                            navigateTo(context, ScannerPrepareOrder(orderId:  orders.orders![index].orderId!,));
                                          },
                                          manualBorderColor: true,
                                          borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor
                                      );
                                    },

                                    separatorBuilder: (context,index)=>const SizedBox(height: 30),

                                    itemCount: orders!.orders!.length
                                ),

                                fallback: (context)=>Center(child: defaultProgressIndicator(context)),
                              ),
                            ),


                          ],
                        ),
                      ),
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

  Widget itemBuilder({required int index,  required OrderModel order})
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children:
      [
        Align(
          alignment: AlignmentDirectional.topStart,
          child: Text(
            '${index+1}.',
            style: headlineTextStyleBuilder(fontSize: 24),
          ),
        ),

        const Spacer(),

        Text(
          '${order.orderId}',
          style: headlineTextStyleBuilder(fontSize: 24),
        ),

        const Spacer(),

        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            order.collectedDate !=null? timePassedSinceByString(order.collectedDate!) : 'Price Date is Null',
            style: headlineTextStyleBuilder(fontSize: 20),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
