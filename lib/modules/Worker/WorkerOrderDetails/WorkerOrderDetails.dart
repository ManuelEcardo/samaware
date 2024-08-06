import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/modules/Worker/WorkerOrderDetails/WorkerOrderItemsDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class WorkerOrderDetails extends StatefulWidget {
  OrderModel order;
  WorkerOrderDetails({super.key, required this.order});

  @override
  State<WorkerOrderDetails> createState() => _WorkerOrderDetailsState();
}

class _WorkerOrderDetailsState extends State<WorkerOrderDetails> {

  List<MOD> items=[];

  @override
  void initState()
  {
    super.initState();

    items.add(MOD(title: 'order_number', value: widget.order.orderId, style: headlineTextStyleBuilder()));
    items.add(MOD(title: 'order_reg_dialog', value: widget.order.registrationDate));
    items.add(MOD(title: 'order_ship_dialog', value: widget.order.shippingDate));

    (widget.order.preparationTeam?.length != 0)? items.add(MOD(title: 'chosen_preparation_team', value: '', customWidget:Align(
      alignment: AlignmentDirectional.topEnd,
      child: TextButton(
        child: Text(Localization.translate('show_preparation_members'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyleBuilder(),),
        onPressed: (){_showDialog(context, widget.order.preparationTeam!);},),),) ) : null;

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
              appBar: AppBar(),

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
                                  return itemBuilder(title: items[index].title, value: items[index].value, style: items[index].style, customWidget: items[index].customWidget);
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
                                navigateTo(context, WorkerOrderItemsDetails(order: widget.order,));
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
                                  navigateTo(context, WorkerOrderItemsDetails(order: widget.order,));
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

        customWidget??
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

  ///Shows the preparationTeam
  void _showDialog(BuildContext context, List<String> members)
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
}
