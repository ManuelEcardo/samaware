import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class InspectorOrderItemsDetails extends StatefulWidget {
  OrderModel order;
  InspectorOrderItemsDetails({super.key, required this.order});

  @override
  State<InspectorOrderItemsDetails> createState() => _InspectorOrderItemsDetailsState();
}

class _InspectorOrderItemsDetailsState extends State<InspectorOrderItemsDetails> {

  late ScrollController scrollController;

  @override
  void initState()
  {
    super.initState();
    scrollController= ScrollController();
  }

  @override
  void dispose() {
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
              appBar: AppBar(),

              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children:
                  [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,

                      children: [
                        Text(
                          Localization.translate('items_details_title'),

                          style: headlineTextStyleBuilder(),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20,),

                    Padding(
                      padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                      child: myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),
                    ),

                    const SizedBox(height: 35,),

                    Expanded(
                      child: Scrollbar(
                        controller: scrollController,
                        thumbVisibility: true,
                        scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,

                        child: ListView.separated(
                            controller: scrollController,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: widget.order.items![index]),
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
                            itemCount: widget.order.items!.length
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          );
        }
    );
  }

  Widget itemBuilder({required AppCubit cubit, required OrderItem item})
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


          ],
        ),
      ],
    );
  }
}
