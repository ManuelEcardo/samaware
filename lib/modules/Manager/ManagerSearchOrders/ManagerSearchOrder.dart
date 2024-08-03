

import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSearchOrders/ManageSearchOrderDetails.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerSearchOrder extends StatefulWidget {
  const ManagerSearchOrder({super.key});

  @override
  State<ManagerSearchOrder> createState() => _ManagerSearchOrderState();
}

class _ManagerSearchOrderState extends State<ManagerSearchOrder> {

  TextEditingController idController = TextEditingController();
  var formKey = GlobalKey<FormState>();

  String? workerId;
  String? priceSetterId;
  String? inspectorId;
  String? status;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state)
      {
        if(state is AppSearchOrdersErrorState)
        {
          defaultToast(msg: 'Error while searching orders');
        }

        if(state is AppSearchOrdersSuccessState)
        {
          navigateTo(context, const ManageSearchOrderDetails());
        }
      },

      builder: (context,state)
      {
        var cubit = AppCubit.get(context);
        return Directionality(
          textDirection: appDirectionality(),
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: defaultAppBar(cubit: cubit, text: Localization.translate('search',)),

            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: formKey,
                child: OrientationBuilder(
                  builder: (context,orientation)
                  {
                    if(orientation == Orientation.portrait)
                    {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children:
                        [
                          Text(Localization.translate('search_by_id'), style: textStyleBuilder(),),

                          const SizedBox(height: 15,),

                          defaultFormField(
                              controller: idController,
                              keyboard: TextInputType.text,
                              label: Localization.translate('search_by_id_label'),
                              prefix: Icons.numbers_outlined,
                              contentPadding: 20,
                              validate: (value)
                              {
                                return null;
                              }
                          ),

                          const SizedBox(height: 15,),

                          Text(Localization.translate('search_by_worker'), style: textStyleBuilder(),),

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
                                    value: workerId,
                                    isDense: true,
                                    onChanged: (newValue)
                                    {
                                      setState(() {
                                        workerId=newValue;
                                      });
                                    },
                                    items: cubit.workers?.workers?.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.worker?.id,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${value.worker?.name} ${value.worker?.lastName}',
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

                          Text(Localization.translate('search_by_priceSetter'), style: textStyleBuilder(),),

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
                                    value: priceSetterId,
                                    isDense: true,
                                    onChanged: (newValue)
                                    {
                                      setState(() {
                                        priceSetterId=newValue;
                                      });
                                    },
                                    items: cubit.priceSetters?.priceSetters?.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.priceSetter?.id,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${value.priceSetter?.name} ${value.priceSetter?.lastName}',
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

                          Text(Localization.translate('search_by_inspector'), style: textStyleBuilder(),),

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
                                    value: inspectorId,
                                    isDense: true,
                                    onChanged: (newValue)
                                    {
                                      setState(() {
                                        inspectorId=newValue;
                                      });
                                    },
                                    items: cubit.inspectors?.inspectors?.map((value) {
                                      return DropdownMenuItem<String>(
                                        value: value.inspector?.id,
                                        child: Row(
                                          children: [
                                            Text(
                                              '${value.inspector?.name} ${value.inspector?.lastName}',
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

                          Text(Localization.translate('serach_by_status'), style: textStyleBuilder(),),

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
                                    value: status, //!=null? Localization.translate(status!) : status,
                                    isDense: true,
                                    onChanged: (newValue)
                                    {
                                      setState(() {
                                        status=newValue;
                                      });
                                    },
                                    items: OrderState.values.toList().map((value){
                                        return DropdownMenuItem<String>(
                                          value: value.name,
                                          child: Row(
                                            children: [
                                              Text(
                                                Localization.translate(value.name),
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

                          const Spacer(),

                          ConditionalBuilder(
                            condition: state is AppSearchOrdersLoadingState,
                            builder: (context) => Center(child: defaultProgressIndicator(context),),

                            fallback: (context)=>Center(
                              child: defaultButton(
                                title: Localization.translate('search_button'),
                                color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                onTap: ()
                                {
                                  if(formKey.currentState!.validate())
                                  {
                                    if(priceSetterId == null && workerId == null && inspectorId ==null && idController.value.text.isEmpty && status == null)
                                    {
                                      defaultToast(msg: 'All Filters are empty');
                                    }

                                    else
                                    {
                                      cubit.searchForOrders(id: idController.value.text, workerId: workerId, inspectorId: inspectorId, priceSetterId: priceSetterId, status: status);
                                    }
                                  }
                                },
                              ),
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
                          children:
                          [
                            Text(Localization.translate('search_by_id'), style: textStyleBuilder(),),

                            const SizedBox(height: 25,),

                            defaultFormField(
                                controller: idController,
                                keyboard: TextInputType.text,
                                label: Localization.translate('search_by_id_label'),
                                prefix: Icons.numbers_outlined,
                                validate: (value)
                                {
                                  return null;
                                }
                            ),

                            const SizedBox(height: 25,),

                            Text(Localization.translate('search_by_worker'), style: textStyleBuilder(),),

                            const SizedBox(height: 25,),

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
                                      value: workerId,
                                      isDense: true,
                                      onChanged: (newValue)
                                      {
                                        setState(() {
                                          workerId=newValue;
                                        });
                                      },
                                      items: cubit.workers?.workers?.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.worker?.id,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${value.worker?.name} ${value.worker?.lastName}',
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


                            const SizedBox(height: 25,),

                            Text(Localization.translate('search_by_priceSetter'), style: textStyleBuilder(),),

                            const SizedBox(height: 25,),

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
                                      value: priceSetterId,
                                      isDense: true,
                                      onChanged: (newValue)
                                      {
                                        setState(() {
                                          priceSetterId=newValue;
                                        });
                                      },
                                      items: cubit.priceSetters?.priceSetters?.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.priceSetter?.id,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${value.priceSetter?.name} ${value.priceSetter?.lastName}',
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

                            const SizedBox(height: 25,),

                            Text(Localization.translate('search_by_inspector'), style: textStyleBuilder(),),

                            const SizedBox(height: 25,),

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
                                      value: inspectorId,
                                      isDense: true,
                                      onChanged: (newValue)
                                      {
                                        setState(() {
                                          inspectorId=newValue;
                                        });
                                      },
                                      items: cubit.inspectors?.inspectors?.map((value) {
                                        return DropdownMenuItem<String>(
                                          value: value.inspector?.id,
                                          child: Row(
                                            children: [
                                              Text(
                                                '${value.inspector?.name} ${value.inspector?.lastName}',
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

                            const SizedBox(height: 25,),

                            Text(Localization.translate('serach_by_status'), style: textStyleBuilder(),),

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
                                      value: status, //!=null? Localization.translate(status!) : status,
                                      isDense: true,
                                      onChanged: (newValue)
                                      {
                                        setState(() {
                                          status=newValue;
                                        });
                                      },
                                      items: OrderState.values.toList().map((value){
                                        return DropdownMenuItem<String>(
                                          value: value.name,
                                          child: Row(
                                            children: [
                                              Text(
                                                Localization.translate(value.name),
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

                            const SizedBox(height: 25,),

                            ConditionalBuilder(
                              condition: state is AppSearchOrdersLoadingState,
                              builder: (context) => Center(child: defaultProgressIndicator(context),),

                              fallback: (context)=>Center(
                                child: defaultButton(
                                  title: Localization.translate('search_button'),
                                  color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                                  textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                                  onTap: ()
                                  {
                                    if(formKey.currentState!.validate())
                                    {
                                      if(priceSetterId == null && workerId == null && inspectorId ==null && idController.value.text.isEmpty && status == null)
                                      {
                                        defaultToast(msg: 'All Filters are empty');
                                      }
                                      else
                                      {

                                        cubit.searchForOrders(id: idController.value.text, workerId: workerId, inspectorId: inspectorId, priceSetterId: priceSetterId, status: status);
                                      }
                                    }
                                  },
                                ),
                              ),
                            ),

                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
