import 'package:samaware_flutter/models/SalesmenModel/SalesmenModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerSalesmanDetails extends StatefulWidget {
  SalesmanModel salesman;

  ManagerSalesmanDetails({super.key, required this.salesman});

  @override
  State<ManagerSalesmanDetails> createState() => _ManagerSalesmanDetailsState();
}

class _ManagerSalesmanDetailsState extends State<ManagerSalesmanDetails> {

  List<MOD> items=[];

  @override
  void initState() {
    super.initState();

    items.add(MOD(title: Localization.translate('salesman_id_title'), value: widget.salesman.salesmanId));
    items.add(MOD(title: Localization.translate('salesman_clients_title'), value: '', customWidget: Align(
      alignment: AlignmentDirectional.topEnd,
      child: TextButton(
        child: Text(Localization.translate('salesman_show_clients'),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyleBuilder(color: AppCubit.get(context).isDarkTheme? defaultThirdDarkColor : defaultThirdColor),),
        onPressed: (){
          //Todo: get this salesman clients
        },),)));
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: defaultAppBar(
              cubit: cubit,
              text: Localization.translate('salesman_details_title')
            ),

            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: OrientationBuilder(
                builder: (context,orientation)
                {
                  if(orientation == Orientation.portrait)
                  {
                    return Column(

                      children:
                      [
                        Center(
                          child: Text(
                            widget.salesman.name!,
                            style: headlineTextStyleBuilder(),
                          ),
                        ),

                        const SizedBox(height: 25,),

                        myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),

                        const SizedBox(height: 25,),

                        Expanded(
                            child: ListView.separated(
                              itemBuilder: (context,index)=>itemBuilder(title: items[index].title, value: items[index].value, customWidget: items[index].customWidget, style: items[index].style),
                              separatorBuilder: (context,index)=>const SizedBox(height: 25,),
                              itemCount: items.length
                            )
                        ),


                      ],
                    );
                  }

                  else
                  {
                    //ToDo: do the landscape mode
                    return const Placeholder();
                  }
                },
              ),
            ),
          ),
        );
      },
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
}
