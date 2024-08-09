import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerEditOrder extends StatefulWidget
{
  OrderModel order;
  ManagerEditOrder({super.key, required this.order});

  @override
  State<ManagerEditOrder> createState() => _ManagerEditOrderState();
}

class _ManagerEditOrderState extends State<ManagerEditOrder> {

  TextEditingController orderIdController= TextEditingController();
  TextEditingController fatouraIdController= TextEditingController();
  var formKey=GlobalKey<FormState>();
  //TextEditingController preparationTeamController= TextEditingController();

  String? destination;
 // List<String> prepTeam=[];

  @override
  void initState() {
    super.initState();

    if(widget.order.orderId !=null) orderIdController.text= widget.order.orderId!;

    if(widget.order.fatouraId !=null) fatouraIdController.text= widget.order.fatouraId!;

    if(widget.order.destination !=null) destination = widget.order.destination!;

    // if(widget.order.preparationTeam !=null)
    // {
    //   prepTeam = widget.order.preparationTeam!;
    //
    //   preparationTeamController.text = widget.order.preparationTeam!.toString().replaceAll('[', '').replaceAll(']','').replaceAll(',', '');
    // }
  }

  @override
  void dispose() {
    orderIdController.dispose();
    fatouraIdController.dispose();

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
            appBar: defaultAppBar(cubit: cubit, text: Localization.translate('alter_order_appBar')),

            body: Padding(
              padding: const EdgeInsets.all(24.0),

              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                    [
                      Text(
                        Localization.translate('alter_order_id'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 15,),

                      defaultFormField(
                          controller: orderIdController,
                          keyboard: TextInputType.number,
                          label: Localization.translate('search_by_id_label'),
                          prefix: Icons.numbers_outlined,
                          contentPadding: 20,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return Localization.translate('order_id_null');
                            }
                            return null;
                          }
                      ),

                      const SizedBox(height: 15,),

                      Text(
                        Localization.translate('alter_order_fatoura_id'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 15,),

                      defaultFormField(
                          controller: fatouraIdController,
                          keyboard: TextInputType.number,
                          label: Localization.translate('alter_order_fatoura_id'),
                          prefix: Icons.numbers_outlined,
                          contentPadding: 20,
                          validate: (value)
                          {
                            if(value!.isEmpty)
                            {
                              return Localization.translate('fatoura_id_null');
                            }
                            return null;
                          }
                      ),

                      const SizedBox(height: 15,),

                      Text(
                        Localization.translate('alter_order_destination'),
                        style: textStyleBuilder(),
                      ),

                      const SizedBox(height: 15,),

                      FormField<String>(

                        builder: (FormFieldState<String> state) {
                          return InputDecorator(
                            decoration: const InputDecoration(
                              focusedBorder: InputBorder.none,
                              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                            ),

                            child: DropdownButtonHideUnderline(

                              child: DropdownButton<String>(

                                style: TextStyle(
                                    color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                ),
                                value: destination,
                                dropdownColor: cubit.isDarkTheme? defaultCanvasDarkColor : defaultCanvasColor,
                                isDense: true,
                                hint: Text(
                                  Localization.translate('alter_order_destination'),
                                  style: TextStyle(
                                    color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                                    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                  ),
                                ),
                                onChanged: (newValue) {
                                  setState(() {
                                    destination = newValue;
                                    state.didChange(newValue);
                                  });
                                },
                                items: orderDestination.map((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Row(
                                      children: [
                                        Text(
                                          value,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ],
                                    ),
                                  );
                                }).toList(),

                              ),
                            ),

                          );
                        },
                      ),

                      const SizedBox(height: 15,),

                      Center(
                        child: defaultButton(
                          title: Localization.translate('submit_button'),
                          color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                          textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                          onTap: ()
                          {
                            if(formKey.currentState!.validate())
                            {
                              print('${orderIdController.text} ${widget.order.orderId}');
                              if(fatouraIdController.text == widget.order.fatouraId && orderIdController.text == widget.order.orderId && destination == widget.order.destination)
                              {
                                defaultToast(msg: Localization.translate('fields_are_same'));
                              }

                              else
                              {
                                cubit.patchOrder(
                                  orderId:widget.order.objectId!,
                                  orderObjectId: orderIdController.text,
                                  destination: destination,
                                  fatouraId: fatouraIdController.text,
                                );

                                Navigator.of(context).pop();
                              }
                            }

                            
                            else
                            {
                              defaultToast(msg: Localization.translate('filters_are_empty'));
                            }
                          },
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ),

          ),
        );
      },
    );
  }

  // ///Choose preparation team
  // void _choosePreparationTeamDialog(BuildContext context, AppCubit cubit,)
  // {
  //   showDialog(
  //       context: context,
  //       builder: (dialogContext)
  //       {
  //         return StatefulBuilder(
  //           builder: (context, setState)
  //           {
  //             return Directionality(
  //               textDirection: appDirectionality(),
  //               child: defaultSimpleDialog(
  //                 context: context,
  //                 title: Localization.translate('choose_preparation_team'),
  //                 content:
  //                 [
  //                   SingleChildScrollView(
  //                     child: SizedBox(
  //                       width: double.maxFinite,
  //                       child: ListView.separated(
  //                           shrinkWrap: true,
  //                           physics: const NeverScrollableScrollPhysics(),
  //                           itemBuilder: (context,index)
  //                           {
  //                             return Padding(
  //                               padding: const EdgeInsetsDirectional.symmetric(horizontal: 8.0),
  //                               child: Row(
  //                                 mainAxisAlignment: MainAxisAlignment.start,
  //                                 children: [
  //                                   Text(
  //                                     preparationTeam[index],
  //                                     style: textStyleBuilder(
  //                                       fontSize: 16,
  //                                       color:  AppCubit.get(context).isDarkTheme? Colors.white: Colors.black,
  //                                       fontFamily: AppCubit.language =='ar'? 'Cairo' :'Railway',
  //                                       fontWeight: FontWeight.w400,),
  //                                   ),
  //
  //                                   const Spacer(),
  //
  //                                   Checkbox(
  //                                     value:prepTeam.contains(preparationTeam[index])? true: false,
  //                                     onChanged: (value)
  //                                     {
  //                                       setState(()
  //                                       {
  //                                         if(value == true)
  //                                         {
  //                                           prepTeam.add(preparationTeam[index]);
  //                                           preparationTeamController.text = '${preparationTeamController.text} ${preparationTeam[index]}' ;
  //                                         }
  //
  //                                         else
  //                                         {
  //                                           prepTeam.remove(preparationTeam[index]);
  //                                           preparationTeamController.text.removeFirstEqual(preparationTeam[index]);
  //                                         }
  //                                       });
  //                                     },
  //                                   ),
  //                                 ],
  //                               ),
  //                             );
  //                           },
  //                           separatorBuilder: (context,index)
  //                           {
  //                             return Column(
  //                               children:
  //                               [
  //                                 const SizedBox(height: 10,),
  //
  //                                 Padding(
  //                                   padding: const EdgeInsets.symmetric(horizontal: 24.0),
  //                                   child: myDivider(),
  //                                 ),
  //
  //                                 const SizedBox(height: 10,),
  //                               ],
  //                             );
  //                           },
  //                           itemCount: preparationTeam.length
  //                       ),
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             );
  //           },
  //         );
  //       }
  //   );
  // }
}
