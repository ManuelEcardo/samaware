import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderItemsDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/components/Localization/Localization.dart';
import 'package:samaware_flutter/shared/components/components.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerOrderDetails extends StatelessWidget {

  OrderModel order;
  ManagerOrderDetails({super.key, required this.order});

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

              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(

                  children:
                  [

                    itemBuilder(title: 'order_number', value: order.orderId, style: headlineTextStyleBuilder()),

                    const SizedBox(height: 30,),

                    myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                    const SizedBox(height: 30,),

                    itemBuilder(title: 'chosen_worker', value: order.worker?.name),

                    const SizedBox(height: 20,),

                    itemBuilder(title: 'order_reg_dialog', value: order.registrationDate),

                    const SizedBox(height: 20,),

                    itemBuilder(title: 'order_ship_dialog', value: order.shippingDate),

                    const SizedBox(height: 20,),

                    datesBuilder(order),

                    const Spacer(),

                    defaultButton(
                      title: Localization.translate('view_items_details'),
                      color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                      textColor: cubit.isDarkTheme? Colors.black : defaultFontColor,
                      onTap: ()
                      {
                        navigateTo(context, ManagerOrderItemsDetails(order: order,));
                      }
                    ),

                  ],
                ),
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



  Widget datesBuilder(OrderModel order)
  {
    return Column(
      children:
      [
        itemBuilder(title: 'Calculate Times: ', value: 'to be created'),
      ],
    );
  }
}
