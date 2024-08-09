import 'dart:async';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:samaware_flutter/models/ClientModel/ClientModel.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class InspectorPrepareOrder extends StatefulWidget {
  String orderId;

  InspectorPrepareOrder({super.key, required this.orderId});

  @override
  State<InspectorPrepareOrder> createState() => _InspectorPrepareOrderState();
}

class _InspectorPrepareOrderState extends State<InspectorPrepareOrder> {

  late ScrollController scrollController;
  List<bool> checkBoxValues=[];

  TextEditingController fatouraController = TextEditingController();

  String location=orderDestination[0];

  var formKey=GlobalKey<FormState>();

  //blur the screen if no yes is pressed
  bool isBlurred=true;

  //timer to click each second to show the time
  Timer? timer;


  late DateTime date;

  String? passedTime;

  @override
  void initState()
  {
    super.initState();
    scrollController= ScrollController();

    var cu = AppCubit.get(context);

    fatouraController.text= cu.inWorkingOrder!=null ?  '' : '';

    //initialize the checkboxes with false values
    if (cu.inWorkingOrder !=null && cu.inWorkingOrder!.items != null)
    {
      checkBoxValues = List.filled(cu.inWorkingOrder!.items!.length, false);

      if(cu.inWorkingOrder?.orderId == widget.orderId)
      {
        print('Same ID => correct order');
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_)
    {
      if (cu.inWorkingOrder!.status == OrderState.scanned.name)
      {
        _showDialog(context, cu.inWorkingOrder!);
      }

      if(cu.inWorkingOrder!.beingVerifiedDate !=null)
      {
        date = DateTime.now();
        setTimer(cubit: cu);
      }
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    checkBoxValues=[];

    timer?.cancel();

    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(

      listener: (context,state)
      {},

      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        var order = cubit.inWorkingOrder;
        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: AppBar(
              actions:
              [
                IconButton(
                    onPressed: ()
                    {
                      showDialog(
                          context: context,
                          builder: (dialogContext)
                          {
                            return defaultAlertDialog(
                              context: dialogContext,
                              title: Localization.translate('deny_order'),
                              content: SingleChildScrollView(
                                child:Column(
                                  children:
                                  [
                                    Text(
                                      Localization.translate('deny_order_secondary'),
                                      style: textStyleBuilder(),
                                    ),

                                    const SizedBox(height: 5,),

                                    Row(
                                      children:
                                      [
                                        TextButton(
                                            onPressed: ()
                                            {
                                              Navigator.of(dialogContext).pop(false);
                                              denyOrder(context: context, cubit: cubit, order: order!);
                                            },
                                            child: Text(Localization.translate('exit_app_yes'), style: textStyleBuilder(),)
                                        ),

                                        const Spacer(),

                                        TextButton(
                                          onPressed: ()
                                          {
                                            Navigator.of(dialogContext).pop(false);
                                          },
                                          child: Text(Localization.translate('exit_app_no'), style: textStyleBuilder()),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }
                      );
                    },
                    icon: const Icon(Icons.delete, color: Colors.red)
                ),
              ],
            ),

            body: OrientationBuilder(
              builder: (context,orientation)
              {
                if(orientation == Orientation.portrait)
                {
                  if(order?.status == OrderState.scanned.name)
                  {

                    return Stack(

                      children: [
                        Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children:
                            [
                              textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: (){_showClientDialog(context, order!.clientId!);},
                            child: Text(
                                      'عرض التفاصيل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                          ),)),

                              const SizedBox(height: 15,),

                              myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                              const SizedBox(height: 30,),

                              Expanded(
                                child: Scrollbar(
                                  controller: scrollController,
                                  thumbVisibility: true,
                                  scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                                  child: ListView.separated(
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      physics: const BouncingScrollPhysics(),
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                      separatorBuilder: (context, index)
                                      {
                                        return Column(
                                          children: [

                                            const SizedBox(height: 20,),

                                            Padding(
                                              padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                              child: myDivider(
                                                  color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                              ),
                                            ),

                                            const SizedBox(height: 20,),
                                          ],
                                        );
                                      },
                                      itemCount: order!.items!.length
                                  ),
                                ),
                              ),

                              const SizedBox(height: 30,),

                              defaultButton(
                                  color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                  title: Localization.translate('to_fatoura_button'),
                                  onTap: ()
                                  {
                                    _showFurtherDetailsDialog(context, cubit, order);

                                    // showDialog(
                                    //     context: context,
                                    //     builder: (dialogContext)
                                    //     {
                                    //       return defaultAlertDialog(
                                    //         context: dialogContext,
                                    //         title: Localization.translate('finish_prepare_dialog_title'),
                                    //         content: SingleChildScrollView(
                                    //             child: Column(
                                    //               children:
                                    //               [
                                    //                 Text(
                                    //                   Localization.translate('finish_prepare_dialog_secondary_title'),
                                    //                   style: textStyleBuilder(),
                                    //                 ),
                                    //
                                    //                 const SizedBox(height: 5,),
                                    //
                                    //                 Row(
                                    //                   children:
                                    //                   [
                                    //                     TextButton(
                                    //                         onPressed: ()
                                    //                         {
                                    //                           setState(()
                                    //                           {
                                    //                             cubit.patchOrder(orderId: order.objectId!, status: OrderState.verified, date: defaultDateFormatter.format(DateTime.now()),
                                    //                                 dateType: OrderDate.verified_date, isInspectorWaitingOrders: true, getDoneOrdersInspector: true);
                                    //
                                    //                             Navigator.of(dialogContext).pop();
                                    //                             Navigator.of(context).pop();
                                    //                           });
                                    //                         },
                                    //                         child: Text(Localization.translate('exit_app_yes'), style: textStyleBuilder(),)
                                    //                     ),
                                    //
                                    //                     const Spacer(),
                                    //
                                    //                     TextButton(
                                    //                       onPressed: ()
                                    //                       {
                                    //                         Navigator.of(dialogContext).pop(false);
                                    //                       },
                                    //                       child: Text(Localization.translate('exit_app_no'), style: textStyleBuilder()),
                                    //                     ),
                                    //                   ],
                                    //                 ),
                                    //               ],
                                    //             )
                                    //         ),
                                    //       );
                                    //     }
                                    // );
                                  }
                              ),
                            ],

                          ),
                        ),

                        if(isBlurred)
                          Positioned.fill(
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                              child: Container(
                                //color: Colors.black.withOpacity(0.1),
                              ),
                            ),
                          ),
                      ],
                    );

                  }

                  else
                  {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children:
                        [
                          textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                          const SizedBox(height: 15,),

                          textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                          const SizedBox(height: 15,),

                          textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                          const SizedBox(height: 15,),

                          textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                          const SizedBox(height: 15,),

                          textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                      alignment: AlignmentDirectional.topStart,
                      child: GestureDetector(
                        onTap: (){_showClientDialog(context, order!.clientId!);},
                        child: Text(
                                  'عرض التفاصيل',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                      ),)),

                          const SizedBox(height: 15,),

                          myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                          const SizedBox(height: 30,),

                          Expanded(
                            child: Scrollbar(
                              controller: scrollController,
                              thumbVisibility: true,
                              scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                              child: ListView.separated(
                                  controller: scrollController,
                                  scrollDirection: Axis.vertical,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                  separatorBuilder: (context, index)
                                  {
                                    return Column(
                                      children: [

                                        const SizedBox(height: 20,),

                                        Padding(
                                          padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                          child: myDivider(
                                              color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                          ),
                                        ),

                                        const SizedBox(height: 20,),
                                      ],
                                    );
                                  },
                                  itemCount: order!.items!.length
                              ),
                            ),
                          ),

                          const SizedBox(height: 30,),

                          defaultButton(
                              color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                              title: Localization.translate('to_fatoura_button'),
                              onTap: ()
                              {
                                _showFurtherDetailsDialog(context, cubit, order);
                              }
                          ),
                        ],

                      ),
                    );
                  }
                }

                else
                {
                  if(kIsWeb)
                  {
                    if(order?.status == OrderState.priced.name)
                    {
                      return Stack(

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children:
                              [
                                textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                                const SizedBox(height: 15,),

                                textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                                const SizedBox(height: 15,),

                                textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: (){_showClientDialog(context, order!.clientId!);},
                            child: Text(
                                      'عرض التفاصيل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                          ),)),

                              const SizedBox(height: 15,),

                                myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                                const SizedBox(height: 30,),

                                Expanded(
                                  child: Scrollbar(
                                    controller: scrollController,
                                    thumbVisibility: true,
                                    scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                                    child: ListView.separated(
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        //physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                        separatorBuilder: (context, index)
                                        {
                                          return Column(
                                            children: [

                                              const SizedBox(height: 20,),

                                              Padding(
                                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                                child: myDivider(
                                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                                ),
                                              ),

                                              const SizedBox(height: 20,),
                                            ],
                                          );
                                        },
                                        itemCount: order!.items!.length
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 30,),

                                defaultButton(
                                    color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                    textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                    title: Localization.translate('to_fatoura_button'),
                                    onTap: ()
                                    {
                                      _showFurtherDetailsDialog(context, cubit, order);
                                    }
                                ),
                              ],

                            ),
                          ),

                          if(isBlurred)
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  //color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                        ],
                      );
                    }

                    else
                    {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children:
                          [
                            textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                            const SizedBox(height: 15,),

                            textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                            const SizedBox(height: 15,),

                            textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                            const SizedBox(height: 15,),

                            textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                            const SizedBox(height: 15,),

                            textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                        alignment: AlignmentDirectional.topStart,
                        child: GestureDetector(
                          onTap: (){_showClientDialog(context, order!.clientId!);},
                          child: Text(
                                    'عرض التفاصيل',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                        ),)),

                            const SizedBox(height: 15,),

                            myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                            const SizedBox(height: 30,),

                            Expanded(
                              child: Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                                child: ListView.separated(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    //physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                    separatorBuilder: (context, index)
                                    {
                                      return Column(
                                        children: [

                                          const SizedBox(height: 20,),

                                          Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                            child: myDivider(
                                                color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                            ),
                                          ),

                                          const SizedBox(height: 20,),
                                        ],
                                      );
                                    },
                                    itemCount: order!.items!.length
                                ),
                              ),
                            ),

                            const SizedBox(height: 20,),

                            defaultButton(
                                color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                title: Localization.translate('to_fatoura_button'),
                                onTap: ()
                                {
                                  _showFurtherDetailsDialog(context, cubit, order);
                                }
                            ),
                          ],

                        ),
                      );
                    }
                  }
                  else
                  {
                    if(order?.status == OrderState.priced.name)
                    {
                      return Stack(

                        children: [
                          Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: SingleChildScrollView(
                              child: Column(
                                children:
                                [
                                  textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                                  const SizedBox(height: 15,),

                                  textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                                  const SizedBox(height: 15,),

                                                                textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: (){_showClientDialog(context, order!.clientId!);},
                            child: Text(
                                      'عرض التفاصيل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                          ),)),

                              const SizedBox(height: 15,),

                                  myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                                  const SizedBox(height: 30,),

                                  Scrollbar(
                                    controller: scrollController,
                                    thumbVisibility: true,
                                    scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                                    child: ListView.separated(
                                        controller: scrollController,
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                        separatorBuilder: (context, index)
                                        {
                                          return Column(
                                            children: [

                                              const SizedBox(height: 20,),

                                              Padding(
                                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                                child: myDivider(
                                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                                ),
                                              ),

                                              const SizedBox(height: 20,),
                                            ],
                                          );
                                        },
                                        itemCount: order!.items!.length
                                    ),
                                  ),

                                  const SizedBox(height: 30,),

                                  defaultButton(
                                      color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                      textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                      title: Localization.translate('to_fatoura_button'),
                                      onTap: ()
                                      {
                                        _showFurtherDetailsDialog(context, cubit, order);
                                      }
                                  ),
                                ],

                              ),
                            ),
                          ),

                          if(isBlurred)
                            Positioned.fill(
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                                child: Container(
                                  //color: Colors.black.withOpacity(0.1),
                                ),
                              ),
                            ),
                        ],
                      );
                    }

                    else
                    {
                      return Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: SingleChildScrollView(
                          child: Column(
                            children:
                            [
                              textBuilder(title: 'order_number', value: order?.orderId, style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'passed_time', value: passedTime??'', style: headlineTextStyleBuilder(), alignment: AlignmentDirectional.topEnd),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_name_title', value: order?.clientId?.name),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_location_title', value: order?.clientId?.location),

                              const SizedBox(height: 15,),

                              textBuilder(title: 'client_details_title', value: '', customWidget: Align(
                          alignment: AlignmentDirectional.topStart,
                          child: GestureDetector(
                            onTap: (){_showClientDialog(context, order!.clientId!);},
                            child: Text(
                                      'عرض التفاصيل',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                          ),)),

                              const SizedBox(height: 15,),

                              myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                              const SizedBox(height: 30,),

                              Scrollbar(
                                controller: scrollController,
                                thumbVisibility: true,
                                scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                                child: ListView.separated(
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order.items![index], itemIndex: index),
                                    separatorBuilder: (context, index)
                                    {
                                      return Column(
                                        children: [

                                          const SizedBox(height: 20,),

                                          Padding(
                                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
                                            child: myDivider(
                                                color: cubit.isDarkTheme? defaultDarkColor : defaultColor
                                            ),
                                          ),

                                          const SizedBox(height: 20,),
                                        ],
                                      );
                                    },
                                    itemCount: order!.items!.length
                                ),
                              ),

                              const SizedBox(height: 20,),

                              defaultButton(
                                  color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                  title: Localization.translate('to_fatoura_button'),
                                  onTap: ()
                                  {
                                    _showFurtherDetailsDialog(context, cubit, order);
                                  }
                              ),
                            ],

                          ),
                        ),
                      );
                    }
                  }


                }
              },
            ),
          ),
        );
      },
    );
  }


  ///Prepare the showDialog
  void _showDialog(BuildContext context, OrderModel order)
  {
    showDialog(
      context: context,
      builder: (dialogContext)=>defaultAlertDialog(
        context: dialogContext,
        title: Localization.translate('prepare_order_dialog_title'),
        content: SingleChildScrollView(
            child: Column(
              children:
              [
                Text(
                  Localization.translate('prepare_order_dialog_sec'),
                  style: textStyleBuilder(),
                ),

                const SizedBox(height: 5,),

                Row(
                  children:
                  [
                    TextButton(
                        onPressed: ()
                        {
                          setState(()
                          {
                            myBuilder(cubit: AppCubit.get(context),order: order );
                          });

                          Navigator.of(dialogContext).pop(false);
                        },
                        child: Text(Localization.translate('exit_app_yes'), style: textStyleBuilder(),)
                    ),

                    const Spacer(),

                    TextButton(
                      onPressed: ()
                      {
                        Navigator.of(dialogContext).pop(false);
                        Navigator.of(context).pop(false);
                      },
                      child: Text(Localization.translate('exit_app_no'), style: textStyleBuilder()),
                    ),
                  ],
                ),
              ],
            )
        ),
      ),
      barrierDismissible: false,

    );
  }

  ///Build the information items
  Widget textBuilder({required String title, required var value, TextStyle? style, Widget? customWidget, AlignmentGeometry alignment=AlignmentDirectional.topStart})
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Expanded(
          child: Text(
            Localization.translate(title),

            style: style?? textStyleBuilder(),
          ),
        ),

        Flexible(
          child: customWidget??
              Align(
                alignment: alignment,
                child: Text(
                  '$value',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: style?? textStyleBuilder(),
                ),
              ),
        ),
      ],
    );
  }
  ///Build the item in the order
  Widget itemBuilder({required AppCubit cubit, required OrderItem item, required int itemIndex})
  {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:
      [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children:
          [
            Expanded(
              child: Text(
                item.name!,
                style: textStyleBuilder(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                ),
              ),
            ),

            Text(
              '${item.quantity}',
              style: textStyleBuilder(
                  color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,
                  fontSize: 26,
                  fontWeight: FontWeight.w800
              ),
            ),
          ],
        ),

        const SizedBox(height: 5,),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:
          [
            Expanded(
              child: Text(
                item.itemId!,
                style: textStyleBuilder(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(width: 5,),

            Text(
              '|',
              style: textStyleBuilder(
                  fontSize: 22,
                  isTitle: true,
                  color: cubit.isDarkTheme? defaultThirdDarkColor: defaultThirdColor
              ),
            ),

            const SizedBox(width: 5,),

            Expanded(
              child: Text(
                Localization.translate(item.type!),
                style: textStyleBuilder(
                  fontSize: 18,
                ),
              ),
            ),

            const SizedBox(width: 5,),

            Checkbox(
              value: checkBoxValues[itemIndex],
              onChanged: (value)
              {
                setState(()
                {
                  checkBoxValues[itemIndex]= value!;
                });
              },

            ),
          ],
        ),
      ],
    );
  }

  ///Builds what happens when accepting the dialog
  void myBuilder({required AppCubit cubit, required OrderModel order})
  {
    setState(()
    {
      isBlurred=false;

      date = DateTime.now();

      cubit.patchOrder(orderId: order.objectId!, status: OrderState.being_verified, date: defaultDateFormatter.format(date),
          dateType: OrderDate.being_verified_date, isInspectorWaitingOrders: true, designateInspector: true, userId: AppCubit.userData?.id);

      setTimer(cubit: cubit, passedDate: date);
    });
  }

  /// Starts the timer
  void setTimer({required AppCubit cubit, DateTime? passedDate})
  {
    // Update every second
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t)
    {
      setState(()
      {
        try {
          date=DateTime.now();

          if(passedDate ==null)
          {
            passedTime= durationFormatToHMS(date.difference(defaultDateFormatter.parse(cubit.inWorkingOrder!.beingVerifiedDate!)));

            //print('diff: ${date.difference(defaultDateFormatter.parse(cubit.inWorkingOrder!.beingPreparedDate!))}');
          }

          else
          {
            passedTime = durationFormatToHMS(date.difference(passedDate));

            //print('diff: ${date.difference(passedDate!)}');
          }
        }
        catch (e)
        {
          //print('Could not parse date..., ${e.toString()}');
          //print(stackTrace);
        }
      });
    });
  }

  ///Deny an Order
  void denyOrder({required BuildContext context, required AppCubit cubit, required OrderModel order})
  {
    showDialog(
      context: context,
      builder: (dialogContext)
      {
        return defaultAlertDialog(
          context: dialogContext,
          title: Localization.translate('deny_order_details_title'),
          content: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                Text(Localization.translate('deny_order_details_secondary'), style: textStyleBuilder(),),

                const SizedBox(height: 15,),

                denyOrderReasonBuilder(cubit: cubit, reason: inspectorOrderFailureReasons[0], context: context, dialogContext: dialogContext, order: order),

                const SizedBox(height: 10,),

                denyOrderReasonBuilder(cubit: cubit, reason: inspectorOrderFailureReasons[1], context: context, dialogContext: dialogContext, order:order),
              ],
            ),
          ),
        );
      },
    );
  }

  ///Denied Order Reasons builder
  Widget denyOrderReasonBuilder({required AppCubit cubit, required String reason, required BuildContext context, required BuildContext dialogContext, required OrderModel order})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        cubit.patchOrder(orderId: order.objectId!, status: OrderState.failed, failureReason: reason,);

        Navigator.of(dialogContext).pop();
        Navigator.of(context).pop();
      },
      padding: 15,
      paddingOptions: true,
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Expanded(
            child: Text(
              Localization.translate(reason),
              style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  ///Shows the Client Details
  void _showClientDialog(BuildContext context, ClientModel client)
  {
    TextStyle defaultTextStyle = textStyleBuilder(fontSize: 18, color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black, fontFamily: AppCubit.language =='ar'? 'Cairo' :'Railway', fontWeight: FontWeight.w400,);

    showDialog(
      context: context,
      builder: (dialogContext)
      {
        return defaultSimpleDialog(
          context: dialogContext,
          title: Localization.translate('chosen_client'),
          content:
          [
            Directionality(
              textDirection: appDirectionality(),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: SizedBox(
                    width: double.maxFinite,
                    child: Column(
                      children:
                      [
                        textBuilder(title: 'الاسم', value: client.name, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        textBuilder(title: 'رقم العميل', value: client.clientId, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        textBuilder(title: 'اسم المندوب', value:client.salesman?.name, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        textBuilder(title: 'اسم المحل', value: client.storeName, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        textBuilder(title: 'العنوان', value: client.location, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        textBuilder(title: 'التفاصيل', value: client.details, style: defaultTextStyle),

                        const SizedBox(height: 25,),


                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  ///Builds the Fatoura ID entry and location
  void _showFurtherDetailsDialog(BuildContext context, AppCubit cubit, OrderModel order)
  {
    showDialog(
      context: context,
      builder: (dialogContext)
      {
        return Directionality(
          textDirection: appDirectionality(),
          child: defaultAlertDialog(
            context: dialogContext,
            title: Localization.translate('fatoura_details_title'),

            content: SingleChildScrollView(
              child: SizedBox(
                width: double.maxFinite,
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(
                        Localization.translate('enter_fatoura_details_title'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 25,),

                      defaultFormField(
                        controller: fatouraController,
                        keyboard: TextInputType.number,
                        label: Localization.translate('enter_fatoura_id_title'),
                        prefix: Icons.numbers_outlined ,
                        validate: (value)
                        {
                          if(value!.isEmpty)
                          {
                            return Localization.translate('fatoura_id_error');
                          }

                          return null;
                        },
                        contentPadding: 15

                      ),

                      const SizedBox(height: 25,),

                      Text(
                        Localization.translate('enter_location_title'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 25,),

                      FormField<String>(
                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            ),

                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                style: TextStyle(
                                    color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                ),
                                value: location,
                                dropdownColor: cubit.isDarkTheme? defaultCanvasDarkColor : defaultCanvasColor,

                                isDense: true,
                                onChanged: (newValue) {

                                  setState(() {
                                    location = newValue!;
                                    state.didChange(newValue);
                                  });
                                },
                                items: orderDestination.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 25,),

                      Center(
                        child: defaultButton(
                            color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                            title: Localization.translate('finish_prepare_title'),
                            onTap: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                cubit.patchOrder(
                                    orderId: order.objectId!, status: OrderState.verified, date: defaultDateFormatter.format(DateTime.now()),
                                    dateType: OrderDate.verified_date, isInspectorWaitingOrders: true, getDoneOrdersInspector: true,
                                    fatouraId: fatouraController.text, destination: location);

                                Navigator.of(dialogContext).pop();
                                Navigator.of(context).pop();
                              }
                            }
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }
    );
  }

}
