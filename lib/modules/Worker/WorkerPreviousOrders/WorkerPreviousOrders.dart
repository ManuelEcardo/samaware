import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/modules/Worker/WorkerOrderDetails/WorkerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class WorkerPreviousOrders extends StatelessWidget {
  const WorkerPreviousOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);
        var orders = cubit.workerDoneOrders;

        return ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            physics: const BouncingScrollPhysics(),
            dragDevices: dragDevices,
          ),
          child: RefreshIndicator(
            onRefresh: () async
            {
              cubit.getWorkerDoneOrders();
            },
            child: Directionality(
              textDirection: appDirectionality(),

              child: ConditionalBuilder(
                condition: orders!=null,

                builder: (context)=>Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Align(
                        alignment: AlignmentDirectional.topStart,
                        child: Text(
                          Localization.translate('my_orders_title_worker'),
                          style: headlineTextStyleBuilder(),
                        ),
                      ),

                      const SizedBox(height: 25,),

                      Expanded(
                        child: ListView.separated(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, order: orders.orders?[index]),
                          separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                          itemCount: orders!.orders!.length,
                        ),
                      ),
                    ],
                  ),
                ),

                fallback: (context)=>Center(
                  child: defaultProgressIndicator(context),
                ),
              ),
            ),
          ),
        );
      },

    );
  }

  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required OrderModel? order})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        navigateTo(context, WorkerOrderDetails(order: order!));
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
