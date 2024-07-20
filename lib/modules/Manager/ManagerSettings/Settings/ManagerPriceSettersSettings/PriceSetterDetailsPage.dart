import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/PriceSettersDetailsModel/PriceSettersDetailsModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class PriceSetterDetailsPage extends StatefulWidget {

  PriceSetterDetailsModel priceSetter;

  PriceSetterDetailsPage({super.key, required this.priceSetter});

  @override
  State<PriceSetterDetailsPage> createState() => _PriceSetterDetailsPageState();
}

class _PriceSetterDetailsPageState extends State<PriceSetterDetailsPage> {

  //Scroll Controller & listener for Lazy Loading
  ScrollController scrollController= ScrollController();
  final GlobalKey _key = GlobalKey();

  @override
  void initState() {
    super.initState();

    AppCubit cubit= AppCubit.get(context);

    scrollController.addListener(()
    {
      _onScroll(cubit);
    });
  }

  @override
  void dispose()
  {
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

            body: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(
                physics: const BouncingScrollPhysics(),
                dragDevices: dragDevices,
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                  [
                    Align(
                      alignment: AlignmentDirectional.center,
                      child: Text(
                        '${widget.priceSetter.priceSetter?.name?? 'Worker Name'} ${widget.priceSetter.priceSetter?.lastName?? 'Worker Last'}',
                        style: headlineTextStyleBuilder(),
                      ),
                    ),

                    const SizedBox(height: 10,),

                    myDivider(color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor),

                    const SizedBox(height: 35,),

                    informationBuilder(title: 'workers_details_order_number', value: widget.priceSetter.orders?.length),

                    const SizedBox(height: 50,),

                    if(state is AppGetNextPriceSetterOrdersLoadingState && widget.priceSetter.orders?.length ==0)

                      Center(
                        child: Column(
                          children: [
                            Text(Localization.translate('loading'), style: textStyleBuilder(),),

                            const SizedBox(height: 25,),

                            defaultProgressIndicator(context),
                          ],
                        ),
                      ),

                    Expanded(
                      child: ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        controller: scrollController,
                        key: _key,
                        itemBuilder: (context,index)=>orderItemBuilder(cubit: cubit, context: context, order: widget.priceSetter.orders?[index]),
                        separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                        itemCount: widget.priceSetter.orders!.length,
                      ),
                    ),

                    if(state is AppGetNextPriceSetterOrdersLoadingState && widget.priceSetter.orders?.length !=0)
                      defaultLinearProgressIndicator(context),

                  ],
                ),
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

  ///onScroll Function for to get orders
  void _onScroll(AppCubit cubit)
  {
    //Will Scroll Only and Only if: Got to the end of the list
    if (scrollController.position.pixels == scrollController.position.maxScrollExtent)
    {
      if(widget.priceSetter.pagination?.nextPage !=null)
      {
        print('paginating next priceSetter orders...');
        cubit.getNextPriceSetterOrders(id: widget.priceSetter.priceSetter!.id!, nextPage: widget.priceSetter.pagination?.nextPage);
      }

    }
  }
}
