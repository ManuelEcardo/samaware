import 'package:samaware_flutter/models/InspectorsDetailsModel/InspectorsDetailsModel.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class InspectorDetailsPage extends StatelessWidget {

  InspectorDetailsModel inspector;
  InspectorDetailsPage({super.key, required this.inspector});

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
            appBar: AppBar(),

            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                  Align(
                    alignment: AlignmentDirectional.center,
                    child: Text(
                      '${inspector.inspector?.name?? 'Worker Name'} ${inspector.inspector?.lastName?? 'Worker Last'}',
                      style: headlineTextStyleBuilder(),
                    ),
                  ),

                  const SizedBox(height: 10,),

                  myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),

                  const SizedBox(height: 35,),

                  informationBuilder(title: 'workers_details_order_number', value: inspector.orders?.length),

                  const SizedBox(height: 50,),

                  Expanded(
                    child: ListView.separated(
                      itemBuilder: (context,index)=>orderItemBuilder(cubit: cubit, context: context, order: inspector.orders?[index]),
                      separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                      itemCount: inspector.orders!.length,
                    ),
                  ),

                ],
              ),
            ),
          ),
        );
      },
    );
  }


  ///Build the information items
  Widget informationBuilder({required String title, required var value, TextStyle? style})
  {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,

      children: [
        Expanded(
          child: Text(
            Localization.translate(title),

            style: style?? textStyleBuilder(fontSize: 24),
          ),
        ),

        Align(
          alignment: AlignmentDirectional.topEnd,
          child: Text(
            '$value',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: style?? textStyleBuilder(fontSize: 24),
          ),
        ),
      ],
    );
  }

  ///Build the Order Item
  Widget orderItemBuilder({required AppCubit cubit, required BuildContext context, required OrderModel? order})
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
