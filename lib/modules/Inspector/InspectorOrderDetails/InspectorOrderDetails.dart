import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Inspector/InspectorOrderDetails/InspectorOrderItemsDetails.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class InspectorOrderDetails extends StatefulWidget {
  OrderModel order;
  InspectorOrderDetails({super.key, required this.order});

  @override
  State<InspectorOrderDetails> createState() => _InspectorOrderDetailsState();
}

class _InspectorOrderDetailsState extends State<InspectorOrderDetails> {

  List<MOD> items=[];

  @override
  void initState()
  {
    super.initState();

    items.add(MOD(title: 'order_number', value: widget.order.orderId, style: headlineTextStyleBuilder()));
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

                          const Spacer(),

                          itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                          const SizedBox(height: 40,),

                          defaultButton(
                              title: Localization.translate('view_items_details'),
                              color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                              textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                              onTap: ()
                              {
                                navigateTo(context, InspectorOrderItemsDetails(order: widget.order,));
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

                            const SizedBox(height: 25,),

                            itemBuilder(title: 'order_state_title', value: translateWord(widget.order.status), style: headlineTextStyleBuilder(fontSize: 22)),

                            const SizedBox(height: 60,),

                            defaultButton(
                                title: Localization.translate('view_items_details'),
                                color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                                onTap: ()
                                {
                                  navigateTo(context, InspectorOrderItemsDetails(order: widget.order,));
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
}
