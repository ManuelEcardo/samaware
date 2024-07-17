
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:file_picker/file_picker.dart';
import 'package:samaware_flutter/models/SubmitOrderModel/SubmitOrderModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerCreateOrder extends StatefulWidget {
  const ManagerCreateOrder({super.key});

  @override
  State<ManagerCreateOrder> createState() => _ManagerCreateOrderState();
}

class _ManagerCreateOrderState extends State<ManagerCreateOrder> {

  late ScrollController scrollController;
  @override
  void initState()
  {
    super.initState();

    scrollController = ScrollController();

    //Only to check if the workers list is null for some reason => fire the getWorker api.
    if(AppCubit.get(context).workers ==null)
      {
        AppCubit.get(context).getWorkers();
      }
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

        PlatformFile? excelFile= cubit.excelFile;

        return Directionality(
          textDirection: appDirectionality(),
          child: PopScope(
            child: Scaffold(
              appBar: AppBar(
                actions:
                [
                  ConditionalBuilder(
                    condition: excelFile !=null,
                    builder: (BuildContext context)=> IconButton(
                      onPressed: ()
                      {
                        showDialog(
                          context: context,
                          builder: (dialogContext)
                          {
                            return defaultAlertDialog(
                              context: dialogContext,
                              title: Localization.translate('order_description_dialog'),
                              content: Directionality(
                                textDirection: appDirectionality(),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:
                                    [
                                      Row(
                                        children: [
                                          Text(Localization.translate('order_id_dialog')),

                                          Expanded(
                                            child: Text(
                                              cubit.orderFromExcel!.orderId!,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10,),

                                      Row(
                                        children: [
                                          Text(Localization.translate('order_items_number_dialog')),

                                          Expanded(
                                            child: Text(
                                              '${cubit.orderFromExcel!.items!.length}',
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10,),

                                      Row(
                                        children: [
                                          Text(Localization.translate('order_reg_dialog')),

                                          Expanded(
                                            child: Text(
                                              '${cubit.orderFromExcel!.registrationDate}',
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10,),

                                      Row(
                                        children: [
                                          Text(Localization.translate('order_ship_dialog')),

                                          Expanded(
                                            child: Text(
                                              '${cubit.orderFromExcel!.shippingDate}',
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      icon: const Icon(Icons.help_outline_outlined),
                    ),
                    fallback: (context)=>const SizedBox(),
                  ),
                ],
              ),

              body: Padding(
                padding: const EdgeInsetsDirectional.all(24.0),
                child: ConditionalBuilder(
                  condition: excelFile !=null && cubit.workers !=null,

                  builder: (BuildContext context)
                  {

                    return OrientationBuilder(
                      builder: (context,orientation)
                      {
                        if(orientation == Orientation.portrait)
                        {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.min,
                            children:
                            [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: Text(
                                      Localization.translate('order_number'),

                                      style: headlineTextStyleBuilder(),
                                    ),
                                  ),

                                  Align(
                                    alignment: AlignmentDirectional.topEnd,
                                    child: Text(
                                      '${cubit.orderFromExcel?.orderId}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: headlineTextStyleBuilder(),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20,),

                              Padding(
                                padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                                child: myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),
                              ),

                              const SizedBox(height: 35,),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,

                                children: [
                                  Expanded(
                                    child: Text(
                                      Localization.translate('worker_assignment'),

                                      style: headlineTextStyleBuilder(),
                                    ),
                                  ),

                                  Expanded(
                                    child: FormField<String>(
                                      builder: (FormFieldState<String> state) {
                                        return InputDecorator(
                                          decoration: const InputDecoration(
                                            enabledBorder: InputBorder.none,
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                          ),

                                          child: DropdownButtonHideUnderline(
                                            child: DropdownButton<String>(
                                              style: TextStyle(
                                                  color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                                  fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                              ),
                                              value: cubit.chosenWorker!.id,
                                              isDense: true,
                                              onChanged: (newValue)
                                              {
                                                cubit.setChosenWorker(id: newValue);
                                              },
                                              items: cubit.workers?.workers?.map((value) {
                                                return DropdownMenuItem<String>(
                                                  value: value.id,
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                        '${value.name!} ${value.lastName!}',
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
                                  interactive: true,
                                  child: ListView.separated(
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: cubit.orderFromExcel!.items![index]),
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
                                      itemCount: cubit.orderFromExcel!.items!.length
                                  ),
                                ),
                              ),

                              const SizedBox(height: 15,),

                              Center(
                                child: defaultButton(
                                  title: Localization.translate('submit_button'),
                                  color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                  onTap: ()
                                  {

                                    //This was written for if the user didn't choose a worker=> it will stay the number one but it won't be set at the orderFromExcel since it wasn't created yet
                                    cubit.setChosenWorker(w:cubit.chosenWorker);

                                    cubit.createOrder(cubit.orderFromExcel, context);
                                  },
                                ),
                              ),

                            ],
                          );
                        }

                        else
                        {
                          return SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              mainAxisSize: MainAxisSize.min,
                              children:
                              [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Expanded(
                                      child: Text(
                                        Localization.translate('order_number'),

                                        style: headlineTextStyleBuilder(),
                                      ),
                                    ),

                                    Align(
                                      alignment: AlignmentDirectional.topEnd,
                                      child: Text(
                                        '${cubit.orderFromExcel?.orderId}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: headlineTextStyleBuilder(),
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Padding(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                                  child: myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),
                                ),

                                const SizedBox(height: 35,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,

                                  children: [
                                    Expanded(
                                      child: Text(
                                        Localization.translate('worker_assignment'),

                                        style: headlineTextStyleBuilder(),
                                      ),
                                    ),

                                    Expanded(
                                      child: FormField<String>(
                                        builder: (FormFieldState<String> state) {
                                          return InputDecorator(
                                            decoration: const InputDecoration(
                                              enabledBorder: InputBorder.none,
                                              border: InputBorder.none,
                                              focusedBorder: InputBorder.none,
                                              errorStyle: TextStyle(color: Colors.redAccent, fontSize: 16.0),
                                            ),

                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton<String>(
                                                style: TextStyle(
                                                    color: AppCubit.get(context).isDarkTheme? defaultDarkColor : defaultColor,
                                                    fontFamily: AppCubit.language == 'ar'? 'Cairo' : 'Railway'
                                                ),
                                                value: cubit.chosenWorker!.id,
                                                isDense: true,
                                                onChanged: (newValue)
                                                {
                                                  cubit.setChosenWorker(id: newValue);
                                                },
                                                items: cubit.workers?.workers?.map((value) {
                                                  return DropdownMenuItem<String>(
                                                    value: value.id,
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          '${value.name!} ${value.lastName!}',
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
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 20,),

                                Padding(
                                  padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
                                  child: myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),
                                ),

                                const SizedBox(height: 35,),

                                Scrollbar(
                                  controller: scrollController,
                                  thumbVisibility: true,
                                  scrollbarOrientation: AppCubit.language=='ar'? ScrollbarOrientation.right : ScrollbarOrientation.left,
                                  interactive: true,
                                  child: ListView.separated(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: cubit.orderFromExcel!.items![index]),
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
                                      itemCount: cubit.orderFromExcel!.items!.length
                                  ),
                                ),

                                const SizedBox(height: 15,),

                                Center(
                                  child: defaultButton(
                                    title: Localization.translate('submit_button'),
                                    color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                    textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                    onTap: ()
                                    {

                                      //This was written for if the user didn't choose a worker=> it will stay the number one but it won't be set at the orderFromExcel since it wasn't created yet
                                      cubit.setChosenWorker(w:cubit.chosenWorker);

                                      cubit.createOrder(cubit.orderFromExcel, context);
                                    },
                                  ),
                                ),

                              ],
                            ),
                          );
                        }
                      });
                  },

                  fallback: (BuildContext context)=>Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children:
                    [
                      Text(
                        Localization.translate('create_an_order_manager'),

                        style: headlineTextStyleBuilder(),
                      ),

                      const SizedBox(height: 25,),

                      Align(
                        alignment: AlignmentDirectional.center,
                        child: TextButton(
                          onPressed: ()
                          {
                            pickFile().then((value)
                            {
                              if(value!=null)
                              {
                                cubit.setExcelFile(value);
                                cubit.readFileAndExtractData(value);
                              }

                            }).catchError((error, stackTrace)
                            {
                              print('${Localization.translate('error_importing_file')}, ${error.toString()}');
                              print(stackTrace);
                            });
                          },
                          child: Text(
                            Localization.translate('import_excel'),

                            style: textStyleBuilder(
                              color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
                              fontSize: 22,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),

            onPopInvoked: (didPop)
            {
              cubit.clearOrder();
            },
          ),
        );
      },
    );
  }


  Widget itemBuilder({required AppCubit cubit, required OrderItem item})
  {
    return Dismissible(

      key: Key(item.itemId!),

      onDismissed: (direction)
      {
        cubit.removeItemFromOrder(item);

        defaultToast(msg: Localization.translate('remove_an_item_swap'));
      },

      background: Container(color: Colors.red,),

      confirmDismiss: (direction)
      {
        return showDialog(
          context: context,
          builder: (dialogContext)
          {
            return defaultAlertDialog(
              context: dialogContext,
              title: Localization.translate('delete_item_dialog_title'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children:
                  [
                    Text(Localization.translate('delete_item_secondary_title')),

                    const SizedBox(height: 5,),

                    Row(
                      children:
                      [
                        TextButton(
                            onPressed: ()=>Navigator.of(dialogContext).pop(true), //Navigator.of(context).pop(true),
                            child: Text(Localization.translate('exit_app_yes'))
                        ),

                        const Spacer(),

                        TextButton(
                          onPressed: ()=> Navigator.of(dialogContext).pop(false),
                          child: Text(Localization.translate('exit_app_no')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },

      child: Column(
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


              GestureDetector(
                child: Icon(
                  Icons.add_outlined,
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                ),

                onTap: ()
                {
                  cubit.changeQuantity(item: item, isIncrease: true, isLongPressed: false);
                },
                onLongPress: ()
                {
                    cubit.changeQuantity(item: item, isIncrease: true, isLongPressed: true);
                },
              ),

              const SizedBox(width: 10,),

              GestureDetector(
                child: const Icon(
                  Icons.remove,
                  color:Colors.red ,
                ),

                onTap:()
                {
                  cubit.changeQuantity(item: item, isIncrease: false, isLongPressed: false);
                },
                onLongPress: ()
                {
                  cubit.changeQuantity(item: item, isIncrease: false, isLongPressed: true);
                },
              ),

            ],
          ),
        ],
      ),
    );
  }
}

// class _ManagerCreateOrderState extends State<ManagerCreateOrder> {
//
//   @override
//   void initState()
//   {
//     super.initState();
//   }
//
//   @override
//   void dispose()
//   {
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<AppCubit,AppStates>(
//       listener: (context,state){},
//       builder: (context,state)
//       {
//         var cubit= AppCubit.get(context);
//
//         PlatformFile? excelFile= cubit.excelFile;
//
//         return Directionality(
//           textDirection: appDirectionality(),
//           child: PopScope(
//             child: Scaffold(
//               appBar: AppBar(
//                 actions:
//                 [
//                   ConditionalBuilder(
//                     condition: excelFile !=null,
//                     builder: (BuildContext context)=> IconButton(
//                       onPressed: ()
//                       {
//                         showDialog(
//                           context: context,
//                           builder: (dialogContext)
//                           {
//                             return defaultAlertDialog(
//                               context: dialogContext,
//                               title: Localization.translate('order_description_dialog'),
//                               content: Directionality(
//                                 textDirection: appDirectionality(),
//                                 child: SingleChildScrollView(
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children:
//                                     [
//                                       Row(
//                                         children: [
//                                           Text(Localization.translate('order_id_dialog')),
//
//                                           Expanded(
//                                             child: Text(
//                                               cubit.orderFromExcel!.orderId!,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//                                       const SizedBox(height: 10,),
//
//                                       Row(
//                                         children: [
//                                           Text(Localization.translate('order_items_number_dialog')),
//
//                                           Expanded(
//                                             child: Text(
//                                               '${cubit.orderFromExcel!.items!.length}',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//                                       const SizedBox(height: 10,),
//
//                                       Row(
//                                         children: [
//                                           Text(Localization.translate('order_reg_dialog')),
//
//                                           Expanded(
//                                             child: Text(
//                                               '${cubit.orderFromExcel!.registrationDate}',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//
//                                       const SizedBox(height: 10,),
//
//                                       Row(
//                                         children: [
//                                           Text(Localization.translate('order_ship_dialog')),
//
//                                           Expanded(
//                                             child: Text(
//                                               '${cubit.orderFromExcel!.shippingDate}',
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         );
//                       },
//                       icon: const Icon(Icons.help_outline_outlined),
//                     ),
//                     fallback: (context)=>const SizedBox(),
//                   ),
//                 ],
//               ),
//
//               body: SingleChildScrollView(
//                 child: Padding(
//                   padding: const EdgeInsetsDirectional.all(24.0),
//                   child: ConditionalBuilder(
//                     condition: excelFile !=null,
//
//                     builder: (BuildContext context)
//                     {
//
//                       return Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                         mainAxisSize: MainAxisSize.min,
//                         children:
//                         [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.start,
//
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   Localization.translate('order_number'),
//
//                                   style: headlineTextStyleBuilder(),
//                                 ),
//                               ),
//
//                               Align(
//                                 alignment: AlignmentDirectional.topEnd,
//                                 child: Text(
//                                   '${cubit.orderFromExcel?.orderId}',
//                                   maxLines: 1,
//                                   overflow: TextOverflow.ellipsis,
//                                   style: headlineTextStyleBuilder(),
//                                 ),
//                               ),
//                             ],
//                           ),
//
//                           const SizedBox(height: 20,),
//
//                           Padding(
//                             padding: const EdgeInsetsDirectional.symmetric(horizontal: 12.0),
//                             child: myDivider(color: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor),
//                           ),
//
//                           const SizedBox(height: 35,),
//
//                           ListView.separated(
//                               physics: const NeverScrollableScrollPhysics(),
//                               itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: cubit.orderFromExcel!.items![index]),
//                               separatorBuilder: (context, index)
//                               {
//                                 return Column(
//                                   children: [
//
//                                     const SizedBox(height: 20,),
//
//                                     Padding(
//                                       padding: const EdgeInsetsDirectional.symmetric(horizontal: 48.0),
//                                       child: myDivider(
//                                           color: cubit.isDarkTheme? defaultDarkColor : defaultColor
//                                       ),
//                                     ),
//
//                                     const SizedBox(height: 20,),
//                                   ],
//                                 );
//                               },
//                               shrinkWrap: true,
//                               itemCount: cubit.orderFromExcel!.items!.length
//                           ),
//
//                           const SizedBox(height: 15,),
//
//                           Center(
//                             child: defaultButton(
//                               title: Localization.translate('submit_button'),
//                               color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
//                               textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
//                               onTap: ()
//                               {
//
//                               },
//                             ),
//                           ),
//
//                         ],
//                       );
//                     },
//
//                     fallback: (BuildContext context)=>Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       mainAxisSize: MainAxisSize.min,
//                       children:
//                       [
//                         Text(
//                           Localization.translate('create_an_order_manager'),
//
//                           style: headlineTextStyleBuilder(),
//                         ),
//
//                         const SizedBox(height: 25,),
//
//                         Align(
//                           alignment: AlignmentDirectional.center,
//                           child: TextButton(
//                             onPressed: ()
//                             {
//                               pickFile().then((value)
//                               {
//                                 if(value!=null)
//                                 {
//                                   cubit.setExcelFile(value);
//                                   cubit.readFileAndExtractData(value);
//                                 }
//
//                               }).catchError((error, stackTrace)
//                               {
//                                 print('${Localization.translate('error_importing_file')}, ${error.toString()}');
//                                 print(stackTrace);
//                               });
//                             },
//                             child: Text(
//                               Localization.translate('import_excel'),
//
//                               style: textStyleBuilder(
//                                 color: cubit.isDarkTheme? defaultDarkColor : defaultColor,
//                                 fontSize: 22,
//                                 decoration: TextDecoration.underline,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             onPopInvoked: (didPop)
//             {
//               cubit.clearOrder();
//             },
//           ),
//         );
//       },
//     );
//   }
//
//   //Reading the excel file and serializing it to object
//   // OrderModel? readFileAndExtractData(String path)
//   // {
//   //   try {
//   //     var bytes = File(path).readAsBytesSync();
//   //
//   //
//   //     var excel = Excel.decodeBytes(bytes);
//   //
//   //     for (var table in excel.tables.keys)
//   //     {
//   //
//   //       if (excel.tables[table] != null)
//   //       {
//   //         final sheet = excel.tables[table]!;
//   //
//   //         print("Rows Number: ${sheet.maxRows}");
//   //
//   //         int id=0;
//   //         String registrationDate='';
//   //         String shippingDate='';
//   //
//   //         // Extracting the first row for order information
//   //         final firstRow = sheet.row(0);
//   //
//   //         //Get Order date and registration data
//   //         for (var cellIndex = 0; cellIndex < firstRow.length; cellIndex++)
//   //         {
//   //           final cell = firstRow[cellIndex];
//   //           if (cell != null)
//   //           {
//   //             if (cell.value.toString().contains('رقم الطلب'))
//   //             {
//   //               String cellValue = cell.value.toString();
//   //               RegExp regExp = RegExp(r'\d+');
//   //               Match? match = regExp.firstMatch(cellValue);
//   //               if (match != null)
//   //               {
//   //
//   //                 //Set Id
//   //                 id= (int.tryParse(match.group(0) ?? '0') ?? 0) ;
//   //
//   //
//   //                 if (cellValue.contains('تاريخ التسجيل')) {
//   //                   final parts = cellValue.split('تاريخ التسجيل');
//   //                   if (parts.length > 1) {
//   //                     final remaining = parts[1];
//   //                     final dateParts = remaining.split('تاريخ التسليم');
//   //
//   //                     print(dateParts[0].trim());
//   //
//   //                     registrationDate = dateParts[0].trim();
//   //                   }
//   //                 }
//   //
//   //                 if (cellValue.contains('تاريخ التسليم')) {
//   //                   final parts = cellValue.split('تاريخ التسليم');
//   //                   if (parts.length > 1){
//   //                     print( parts[1].trim());
//   //
//   //                     shippingDate=parts[1].trim();
//   //                   }
//   //                 }
//   //
//   //               }
//   //             }
//   //
//   //           }
//   //         }
//   //
//   //         //Get Items
//   //         for (var rowIndex = 4; rowIndex < sheet.maxRows; rowIndex++) {
//   //           final row = sheet.row(rowIndex);
//   //
//   //           final id = row[1];
//   //           final itemName = row[2];
//   //           final quantity = row[3];
//   //           final type = row[4];
//   //
//   //           if (id != null && itemName != null && quantity != null && type != null)
//   //           {
//   //             final item = OrderItem(
//   //               itemId: id.value.toString(),
//   //               name: itemName.value.toString(),
//   //               quantity: double.tryParse(quantity.value.toString()) ?? 0,
//   //               type: type.value.toString(),
//   //             );
//   //
//   //             items?.add(item);
//   //           }
//   //           else
//   //           {
//   //             print("Some row is null");
//   //           }
//   //         }
//   //
//   //           print('Items number is ${items?.length}');
//   //           //Creating an order
//   //           return OrderModel.create(id: '$id', regDate: registrationDate, shipDate: shippingDate, itemList: items,);
//   //
//   //       }
//   //
//   //
//   //     }
//   //   }
//   //   catch (e, stackTrace)
//   //   {
//   //     print("Error while manipulating the excel file, $e");
//   //     print(stackTrace.toString());
//   //   }
//   //   return null;
//   // }
//
//   //Order items builder
//   Widget itemBuilder({required AppCubit cubit, required OrderItem item})
//   {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children:
//       [
//         Row(
//           mainAxisAlignment: MainAxisAlignment.start,
//           children:
//           [
//             Expanded(
//               child: Text(
//                 item.name!,
//                 style: textStyleBuilder(
//                   fontFamily: 'Cairo',
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//
//             Text(
//               '${item.quantity}',
//               style: textStyleBuilder(
//                 color: cubit.isDarkTheme? defaultThirdDarkColor : defaultThirdColor,
//                 fontSize: 26,
//                 fontWeight: FontWeight.w800
//               ),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 5,),
//
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children:
//           [
//             Expanded(
//               child: Text(
//                 item.itemId!,
//                 style: textStyleBuilder(
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 5,),
//
//             Text(
//               '|',
//               style: textStyleBuilder(
//                 fontSize: 22,
//                 isTitle: true,
//                 color: cubit.isDarkTheme? defaultThirdDarkColor: defaultThirdColor
//               ),
//             ),
//
//             const SizedBox(width: 5,),
//
//             Expanded(
//               child: Text(
//                 Localization.translate(item.type!),
//                 style: textStyleBuilder(
//                   fontSize: 18,
//                 ),
//               ),
//             ),
//
//
//             GestureDetector(
//               child: IconButton(
//                 onPressed: ()
//                 {
//                   cubit.orderFromExcel!.items?.forEach((i)
//                   {
//                     if(item.itemId! == i.itemId!)
//                       {
//                         setState(() {
//                           i.setQuantity(i.quantity!+1);
//                         });
//                       }
//                   });
//                 },
//
//                 icon: Icon(
//                   Icons.add_outlined,
//                   color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
//                 ),
//               ),
//
//               onLongPress: ()
//               {
//                 cubit.orderFromExcel!.items?.forEach((i)
//                 {
//                   if(item.itemId! == i.itemId!)
//                   {
//                     setState(() {
//                       i.setQuantity(i.quantity!+0.5);
//                     });
//                   }
//                 });
//               },
//             ),
//
//             GestureDetector(
//               child: IconButton(
//                 onPressed: ()
//                 {
//                   cubit.orderFromExcel!.items?.forEach((i)
//                   {
//                     if(item.itemId! == i.itemId!)
//                     {
//                       setState(() {
//                         i.setQuantity(i.quantity!-1);
//                       });
//                     }
//                   });
//                 },
//                 icon: const Icon(
//                   Icons.remove,
//                   color:Colors.red ,
//                 ),
//               ),
//
//               onLongPress: ()
//               {
//                 cubit.orderFromExcel!.items?.forEach((i)
//                 {
//                   if(item.itemId! == i.itemId!)
//                   {
//                     setState(() {
//                       i.setQuantity(i.quantity!-0.5);
//                     });
//                   }
//                 });
//               },
//             ),
//
//           ],
//         ),
//       ],
//     );
//   }
// }
