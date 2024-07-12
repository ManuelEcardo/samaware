import 'dart:io';

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_excel/excel.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerCreateOrder extends StatefulWidget {
  const ManagerCreateOrder({super.key});

  @override
  State<ManagerCreateOrder> createState() => _ManagerCreateOrderState();
}

class _ManagerCreateOrderState extends State<ManagerCreateOrder> {

  PlatformFile? excelFile;
  String? excelFilePath;

  OrderModel? order;
  List<OrderItem>? items=[];

  @override
  void initState()
  {
    super.initState();
  }

  @override
  void dispose()
  {
    super.dispose();
    excelFile=null;
    excelFilePath=null;
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
            appBar: AppBar(
              actions:
              [
                ConditionalBuilder(
                  condition: excelFile !=null && excelFilePath !=null,
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
                                            order!.orderId!,
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
                                            '${order!.items!.length}',
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
                                            '${order!.registrationDate}',
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
                                            '${order!.shippingDate}',
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

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24.0),
                child: ConditionalBuilder(
                  condition: excelFile !=null && excelFilePath !=null,

                  builder: (BuildContext context)
                  {
                    print('got file, $excelFilePath');

                    //order = readFileAndExtractData(excelFilePath!);

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
                                '${order?.orderId}',
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

                        ListView.separated(
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context,index)=>itemBuilder(cubit: cubit, item: order!.items![index]),
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
                          shrinkWrap: true,
                          itemCount: order!.items!.length
                        ),

                        const SizedBox(height: 15,),

                        Center(
                          child: defaultButton(
                            title: Localization.translate('submit_button'),
                            color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                            onTap: ()
                            {

                            },
                          ),
                        ),

                      ],
                    );
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
                                  setState(()
                                  {
                                    excelFile = value;
                                    excelFilePath= value.path;

                                    order = readFileAndExtractData(excelFilePath!);
                                  });
                                }
                            }).catchError((error)
                            {
                              print('${Localization.translate('error_importing_file')}, ${error.toString()}');
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
          ),
        );
      },
    );
  }

  //Reading the excel file and serializing it to object
  OrderModel? readFileAndExtractData(String path)
  {
    try {
      var bytes = File(path).readAsBytesSync();

      var excel = Excel.decodeBytes(bytes);

      for (var table in excel.tables.keys)
      {

        if (excel.tables[table] != null)
        {
          final sheet = excel.tables[table]!;

          print("Rows Number: ${sheet.maxRows}");

          int id=0;
          String registrationDate='';
          String shippingDate='';

          // Extracting the first row for order information
          final firstRow = sheet.row(0);

          //Get Order date and registration data
          for (var cellIndex = 0; cellIndex < firstRow.length; cellIndex++)
          {
            final cell = firstRow[cellIndex];
            if (cell != null)
            {
              if (cell.value.toString().contains('رقم الطلب'))
              {
                String cellValue = cell.value.toString();
                RegExp regExp = RegExp(r'\d+');
                Match? match = regExp.firstMatch(cellValue);
                if (match != null)
                {

                  //Set Id
                  id= (int.tryParse(match.group(0) ?? '0') ?? 0) ;


                  if (cellValue.contains('تاريخ التسجيل')) {
                    final parts = cellValue.split('تاريخ التسجيل');
                    if (parts.length > 1) {
                      final remaining = parts[1];
                      final dateParts = remaining.split('تاريخ التسليم');

                      print(dateParts[0].trim());

                      registrationDate = dateParts[0].trim();
                    }
                  }

                  if (cellValue.contains('تاريخ التسليم')) {
                    final parts = cellValue.split('تاريخ التسليم');
                    if (parts.length > 1){
                      print( parts[1].trim());

                      shippingDate=parts[1].trim();
                    }
                  }

                }
              }

            }
          }

          //Get Items
          for (var rowIndex = 4; rowIndex < sheet.maxRows; rowIndex++) {
            final row = sheet.row(rowIndex);

            final id = row[1];
            final itemName = row[2];
            final quantity = row[3];
            final type = row[4];

            if (id != null && itemName != null && quantity != null && type != null)
            {
              final item = OrderItem(
                itemId: id.value.toString(),
                name: itemName.value.toString(),
                quantity: double.tryParse(quantity.value.toString()) ?? 0,
                type: type.value.toString(),
              );

              items?.add(item);
            }
            else
            {
              print("Some row is null");
            }
          }

            print('Items number is ${items?.length}');
            //Creating an order
            return OrderModel.create(id: '$id', regDate: registrationDate, shipDate: shippingDate, itemList: items,);

        }


      }
    }
    catch (e, stackTrace)
    {
      print("Error while manipulating the excel file, $e");
      print(stackTrace.toString());
    }
    return null;
  }

  //Order items builder
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


            GestureDetector(
              child: IconButton(
                onPressed: ()
                {
                  order!.items?.forEach((i)
                  {
                    if(item.itemId! == i.itemId!)
                      {
                        setState(() {
                          i.setQuantity(i.quantity!+1);
                        });
                      }
                  });
                },

                icon: Icon(
                  Icons.add_outlined,
                  color: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                ),
              ),

              onLongPress: ()
              {
                order!.items?.forEach((i)
                {
                  if(item.itemId! == i.itemId!)
                  {
                    setState(() {
                      i.setQuantity(i.quantity!+0.5);
                    });
                  }
                });
              },
            ),

            GestureDetector(
              child: IconButton(
                onPressed: ()
                {
                  order!.items?.forEach((i)
                  {
                    if(item.itemId! == i.itemId!)
                    {
                      setState(() {
                        i.setQuantity(i.quantity!-1);
                      });
                    }
                  });
                },
                icon: const Icon(
                  Icons.remove,
                  color:Colors.red ,
                ),
              ),

              onLongPress: ()
              {
                order!.items?.forEach((i)
                {
                  if(item.itemId! == i.itemId!)
                  {
                    setState(() {
                      i.setQuantity(i.quantity!-0.5);
                    });
                  }
                });
              },
            ),

          ],
        ),
      ],
    );
  }
}
