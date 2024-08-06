import 'package:intl/intl.dart';
import 'package:samaware_flutter/models/ClientModel/ClientModel.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderItemsDetails.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSalesmanDetails/ManagerSalesmanDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class MOD
{
  String title;
  dynamic value;
  TextStyle? style;
  Widget? customWidget;

  MOD({required this.title, required this.value, this.style, this.customWidget});

}

class ManagerOrderDetails extends StatefulWidget {

  OrderModel order;
  ManagerOrderDetails({super.key, required this.order});

  @override
  State<ManagerOrderDetails> createState() => _ManagerOrderDetailsState();
}

class _ManagerOrderDetailsState extends State<ManagerOrderDetails>
{
  List<MOD> items=[];

  @override
  void initState()
  {
    super.initState();

    //debugPrint(widget.order.toString(), wrapWidth: 1024);

    items.add(MOD(title: 'order_number', value: widget.order.orderId, style: headlineTextStyleBuilder()));

    items.add(MOD(title: 'chosen_worker', value: '${widget.order.worker?.name} ${widget.order.worker?.lastName}'));

    (widget.order.clientId !=null)? items.add(MOD(title: 'chosen_client', value: 'value', customWidget:Align(
      alignment: AlignmentDirectional.topEnd,
      child: TextButton(
        child: Text(
          widget.order.clientId!.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyleBuilder(color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
        onPressed: (){_showClientDialog(context, widget.order.clientId!);},),))) : null;

    (widget.order.preparationTeam?.length != 0)? items.add(MOD(title: 'chosen_preparation_team', value: '', customWidget:Align(
      alignment: AlignmentDirectional.topEnd,
      child: TextButton(
        child: Text(Localization.translate('show_preparation_members'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyleBuilder(color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
        onPressed: (){_showPreparationTeamDialog(context, widget.order.preparationTeam!);},),),) ) : null;

    (widget.order.priceSetter?.name !=null && widget.order.priceSetter?.name !=null)? items.add(MOD(title: 'chosen_priceSetter', value: '${widget.order.priceSetter?.name} ${widget.order.priceSetter?.lastName}')) : null;

    (widget.order.collector?.name !=null && widget.order.collector?.name !=null)? items.add(MOD(title:'chosen_collector', value:'${widget.order.collector?.name} ${widget.order.collector?.lastName}')) : null;

    (widget.order.scanner?.name !=null && widget.order.scanner?.name !=null)? items.add(MOD(title:'chosen_scanner', value:'${widget.order.scanner?.name} ${widget.order.scanner?.lastName}')) : null;

    (widget.order.inspector?.name !=null && widget.order.inspector?.name !=null)? items.add(MOD(title: 'chosen_inspector', value: '${widget.order.inspector?.name} ${widget.order.inspector?.lastName}')) : null;


    items.add(MOD(title: 'order_reg_dialog', value: widget.order.registrationDate));
    items.add(MOD(title: 'order_ship_dialog', value: widget.order.shippingDate));

  }

  @override
  void dispose() {

    items=[];
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
        listener: (context,state)
        {},
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);

          return Directionality(
            textDirection: appDirectionality(),
            child: Scaffold(
              appBar: AppBar(
                actions:
                [
                  if(widget.order.status == OrderState.verified.name)
                    IconButton(
                      onPressed: ()
                      {
                        navigateTo(context, ManagerOrderItemsDetails(order: widget.order,));
                      },
                      icon: const Icon(Icons.list),
                    ),
                ],
              ),

              body: OrientationBuilder(
                builder: (context,orientation)
                {
                  if(orientation == Orientation.portrait)
                  {
                    return Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(

                        children:
                        [
                          Expanded(
                            child: ListView.separated(
                              itemBuilder: (context,index)
                              {
                                return index != items.length-1
                                    ?itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style, customWidget: items[index].customWidget)
                                    : Column(children:[

                                      itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style, customWidget: items[index].customWidget),

                                      datesBuilder(widget.order),

                                      if(widget.order.status == OrderState.failed.name)
                                        const SizedBox(height: 25,),

                                      if(widget.order.status == OrderState.failed.name)
                                        itemBuilder(title: Localization.translate('failure_reason_odm'), value: Localization.translate('${widget.order.failureReason}'), customWidget: items[index].customWidget),
                                ],);
                              },

                              separatorBuilder: (context,index)
                              {
                                return index!=0? const SizedBox(height: 25,) : Column(
                                  children:
                                  [
                                    const SizedBox(height: 30,),

                                    myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                                    const SizedBox(height: 30,),
                                  ],
                                ) ;

                              },
                              itemCount: items.length
                            ),
                          ),

                          const SizedBox(height: 40,),

                          itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                          const SizedBox(height: 40,),

                          defaultButton(
                              title: widget.order.status != OrderState.verified.name
                                  ? (widget.order.status != OrderState.stored.name)? Localization.translate('view_items_details') : Localization.translate('to_shipment_button')
                                  : Localization.translate('to_shipment_store'),
                              color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                              onTap: ()
                              {

                                widget.order.status != OrderState.verified.name
                                    ? (widget.order.status != OrderState.stored.name)? navigateTo(context, ManagerOrderItemsDetails(order: widget.order,)) : toShip(cubit: cubit, order: widget.order, context: context)

                                    :alertDialog(context: context, order: widget.order, cubit: cubit);
                              }
                          ),

                        ],
                      ),
                    );
                  }

                  else
                  {
                    return SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(

                          children:
                          [
                            ListView.separated(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,

                                itemBuilder: (context,index)
                                {
                                  return index != items.length-1
                                      ?itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style, customWidget: items[index].customWidget)
                                      : Column(children:[

                                    itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style, customWidget: items[index].customWidget),

                                    datesBuilder(widget.order),

                                    if(widget.order.status == OrderState.failed.name)
                                      const SizedBox(height: 25,),

                                    if(widget.order.status == OrderState.failed.name)
                                      itemBuilder(title: Localization.translate('failure_reason_odm'), value: Localization.translate('${widget.order.failureReason}'), customWidget: items[index].customWidget),
                                  ],);

                                },

                                separatorBuilder: (context,index)
                                {
                                  return index!=0? const SizedBox(height: 50,) : Column(
                                    children:
                                    [
                                      const SizedBox(height: 35,),

                                      myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                                      const SizedBox(height: 35,),
                                    ],
                                  ) ;

                                },
                                itemCount: items.length
                            ),

                            //datesBuilder(widget.order),

                            const SizedBox(height: 25,),

                            itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                            const SizedBox(height: 60,),

                            defaultButton(
                                title: widget.order.status != OrderState.verified.name
                                    ? (widget.order.status != OrderState.stored.name)? Localization.translate('view_items_details') : Localization.translate('to_shipment_button')
                                    : Localization.translate('to_shipment_store'),
                                
                                color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                                onTap: ()
                                {
                                  widget.order.status != OrderState.verified.name
                                      ? (widget.order.status != OrderState.stored.name)? navigateTo(context, ManagerOrderItemsDetails(order: widget.order,)) : toShip(cubit: cubit, order: widget.order, context: context)

                                      :alertDialog(context: context, order: widget.order, cubit: cubit);
                                }
                            ),

                          ],
                        ),
                      ),
                    );
                  }
                },
              ),
            ),
          );
        }
    );
  }

  ///Build the information items
  Widget itemBuilder({required String title, required var value, TextStyle? style, Widget? customWidget})
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

        customWidget ??
        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            '$value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style?? textStyleBuilder(),
          ),
        ),
      ],
    );
  }

  ///Build the information items
  Widget dateItemBuilder({required String title, required var value, TextStyle? style})
  {
    return Column(
      children: [
        const SizedBox(height: 25,),

        Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            Expanded(
              child: Text(
                Localization.translate(title),

                style: style?? textStyleBuilder(),
              ),
            ),

            Align(
              alignment: AlignmentDirectional.topEnd,
              child: Text(
                '$value',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: style?? textStyleBuilder(),
              ),
            ),
          ],
        ),
      ],
    );
  }

  ///Build calculated times between order states
  Widget datesBuilder(OrderModel order)
  {
    return Column(
      children:
      [
        if(order.waitingToBePreparedDate !=null && order.beingPreparedDate !=null) dateItemBuilder(title:'to_start_prepare_time', value: localFormatter(order.waitingToBePreparedDate!, order.beingPreparedDate!)),

        if(order.preparedDate !=null && order.beingPreparedDate !=null) dateItemBuilder(title:'preparation_time', value: localFormatter(order.beingPreparedDate!, order.preparedDate!)),

        if(order.preparedDate !=null && order.beingPricedDate !=null) dateItemBuilder(title:'to_start_pricing_time' , value: localFormatter(order.preparedDate!, order.beingPricedDate!)),

        if(order.beingPricedDate !=null && order.pricedDate !=null) dateItemBuilder(title:'pricing_time', value: localFormatter(order.beingPricedDate!, order.pricedDate!)),

        if(order.pricedDate !=null && order.beingCollectedDate !=null) dateItemBuilder(title:'to_start_collecting_time' , value: localFormatter(order.pricedDate!, order.beingCollectedDate!)),

        if(order.beingCollectedDate !=null && order.collectedDate !=null) dateItemBuilder(title:'collecting_time' , value: localFormatter(order.beingCollectedDate!, order.collectedDate!)),

        if(order.collectedDate !=null && order.beingScannedDate !=null) dateItemBuilder(title:'to_start_scanning_time' , value: localFormatter(order.collectedDate!, order.beingScannedDate!)),

        if(order.beingScannedDate !=null && order.scannedDate !=null) dateItemBuilder(title:'scanning_time' , value: localFormatter(order.beingScannedDate!, order.scannedDate!)),

        if(order.scannedDate !=null && order.beingVerifiedDate !=null) dateItemBuilder(title:'to_start_verifying_time', value: localFormatter(order.scannedDate!, order.beingVerifiedDate!)),

        if(order.beingVerifiedDate !=null && order.verifiedDate !=null) dateItemBuilder(title:'verifying_time', value: localFormatter(order.beingVerifiedDate!, order.verifiedDate!)),

        if(order.storedDate !=null) dateItemBuilder(title: 'storing_date', value:  DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(order.storedDate!)) ),

        if(order.shippedDate !=null) dateItemBuilder(title: 'shipped_date', value:  DateFormat('dd/MM/yyyy').format(DateFormat('dd/MM/yyyy').parse(order.shippedDate!)) ),
      ],
    );
  }

  String localFormatter(String t1, String t2)
  {
    return durationFormatToHMS( defaultDateFormatter.parse(t2).difference(defaultDateFormatter.parse(t1)));
  }

  ///Shows a dialog between [shipment - storage]
  void alertDialog({required BuildContext context, required AppCubit cubit ,required OrderModel order})
  {
    showDialog(
      context: context,
      builder: (dialogContext)
      {
        return defaultAlertDialog(
            context: dialogContext,
            title: Localization.translate('next_status_after_verify_title'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    Localization.translate('next_status_after_verify_secondary'),
                  ),

                  const SizedBox(height: 5,),

                  Row(
                    children:
                    [
                      TextButton(
                          onPressed: ()
                          {
                            cubit.patchOrder(orderId: widget.order.objectId!, status: OrderState.stored,dateType: OrderDate.stored_date, date: defaultDateFormatter.format(DateTime.now()));

                            Navigator.of(dialogContext).pop();
                            Navigator.of(context).pop();
                          },
                          child: Text(Localization.translate('to_shipment_button'))
                      ),

                      const Spacer(),

                      TextButton(
                        onPressed: ()
                        {
                          cubit.patchOrder(orderId: widget.order.objectId!, status: OrderState.shipped,dateType: OrderDate.shipped_date, date: defaultDateFormatter.format(DateTime.now()));

                          Navigator.of(dialogContext).pop();
                          Navigator.of(context).pop();
                        },
                        child: Text(Localization.translate('to_storage_button')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
        );
      },
    );
  }

  ///Sets the order state to shipped
  void toShip({required AppCubit cubit, required OrderModel order, required BuildContext context})
  {
    cubit.patchOrder(orderId: order.objectId!, status: OrderState.shipped, dateType: OrderDate.shipped_date, date: defaultDateFormatter.format(DateTime.now()) );

    Navigator.of(context).pop();
  }

  ///Shows the preparationTeam
  void _showPreparationTeamDialog(BuildContext context, List<String> members)
  {
    showDialog(
      context: context,
      builder: (dialogContext)
      {
        return defaultSimpleDialog(
            context: dialogContext,
            title: Localization.translate('show_preparation_members'),
            content:
            [
              Directionality(
                textDirection: appDirectionality(),
                child: SingleChildScrollView(
                  child: SizedBox(
                    width: double.maxFinite,
                    child: ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context,index)
                        {
                          return Padding(
                            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
                            child: Text(
                              members[index],
                              style: textStyleBuilder(
                                fontSize: 16,
                                color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
                                fontFamily: AppCubit.language =='ar'? 'Cairo' :'Railway',
                                fontWeight: FontWeight.w400,),
                            ),
                          );
                        },
                        separatorBuilder: (context,index)
                        {
                          return Column(
                            children:
                            [
                              const SizedBox(height: 10,),

                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 1.0),
                                child: myDivider(),
                              ),

                              const SizedBox(height: 10,),
                            ],
                          );
                        },
                        itemCount: members.length
                    ),
                  ),
                ),
              ),
            ],
        );
      },
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
                        itemBuilder(title: 'الاسم', value: client.name, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        itemBuilder(title: 'رقم العميل', value: client.clientId, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        itemBuilder(title: 'اسم المندوب', value:'', style: defaultTextStyle, customWidget: Align(
                          alignment: AlignmentDirectional.topEnd,
                          child: TextButton(
                            child: Text(
                              client.salesman!.name!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: textStyleBuilder(fontSize: 18, color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
                            onPressed: (){navigateTo(context, ManagerSalesmanDetails(salesman: client.salesman!));},),)),

                        const SizedBox(height: 25,),

                        itemBuilder(title: 'اسم المحل', value: client.storeName, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        itemBuilder(title: 'العنوان', value: client.location, style: defaultTextStyle),

                        const SizedBox(height: 25,),

                        itemBuilder(title: 'التفاصيل', value: client.details, style: defaultTextStyle),

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
}
