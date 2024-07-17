import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderItemsDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/components/constants.dart';

class MOD
{
  String title;
  dynamic value;
  TextStyle? style;

  MOD({required this.title, required this.value, this.style});

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

    items.add(MOD(title: 'order_number', value: widget.order.orderId, style: headlineTextStyleBuilder()));
    items.add(MOD(title: 'chosen_worker', value: '${widget.order.worker?.name} ${widget.order.worker?.lastName}'));

    (widget.order.priceSetter?.name !=null && widget.order.priceSetter?.name !=null)? items.add(MOD(title: 'chosen_priceSetter', value: '${widget.order.priceSetter?.name} ${widget.order.priceSetter?.lastName}')) : null;

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
        {
          // Todo: Update order if changed
        },
        builder: (context,state)
        {
          var cubit=AppCubit.get(context);

          return Scaffold(
            appBar: AppBar(),

            body: Directionality(
              textDirection: appDirectionality(),

              child: OrientationBuilder(
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
                                return itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style);
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

                          datesBuilder(widget.order),

                          const Spacer(),

                          itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                          const SizedBox(height: 40,),

                          defaultButton(
                              title: Localization.translate('view_items_details'),
                              color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                              onTap: ()
                              {
                                navigateTo(context, ManagerOrderItemsDetails(order: widget.order,));
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
                                  return itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style);
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

                            datesBuilder(widget.order),

                            const SizedBox(height: 25,),

                            itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                            const SizedBox(height: 60,),

                            defaultButton(
                                title: Localization.translate('view_items_details'),
                                color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                                onTap: ()
                                {
                                  navigateTo(context, ManagerOrderItemsDetails(order: widget.order,));
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
  Widget itemBuilder({required String title, required var value, TextStyle? style})
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
        const SizedBox(height: 10,),

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

  //Todo: build the datesBuilder

  ///Build calculated times between order states
  Widget datesBuilder(OrderModel order)
  {
    return Column(
      children:
      [
        if(order.waitingToBePreparedDate !=null && order.beingPreparedDate !=null) dateItemBuilder(title:Localization.translate('to_start_prepare_time'), value: localFormatter(order.waitingToBePreparedDate!, order.beingPreparedDate!)),

        if(order.preparedDate !=null && order.beingPreparedDate !=null) dateItemBuilder(title:Localization.translate('preparation_time'), value: localFormatter(order.beingPreparedDate!, order.preparedDate!)),

        if(order.preparedDate !=null && order.beingPricedDate !=null) dateItemBuilder(title:Localization.translate('to_start_pricing_time') , value: localFormatter(order.preparedDate!, order.beingPricedDate!)),

        if(order.beingPricedDate !=null && order.pricedDate !=null) dateItemBuilder(title:Localization.translate('pricing_time'), value: localFormatter(order.beingPricedDate!, order.pricedDate!)),

        if(order.pricedDate !=null && order.beingVerifiedDate !=null) dateItemBuilder(title:Localization.translate('to_start_verifying_time'), value: localFormatter(order.pricedDate!, order.beingVerifiedDate!)),

        if(order.beingVerifiedDate !=null && order.verifiedDate !=null) dateItemBuilder(title:Localization.translate('verifying_time'), value: localFormatter(order.beingVerifiedDate!, order.verifiedDate!)),

      ],
    );
  }

  String localFormatter(String t1, String t2)
  {
    return durationFormatToHMS( defaultDateFormatter.parse(t2).difference(defaultDateFormatter.parse(t1)));
  }
}
