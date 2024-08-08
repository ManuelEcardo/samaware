import 'package:samaware_flutter/models/NewClientsModel/NewClientsModel.dart';
import 'package:samaware_flutter/models/SalesmenModel/SalesmenModel.dart';
import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class ManagerAlterNewClientsSettings extends StatefulWidget {
  SalesmanModel salesman;
  NewClientsModel client;
  int clientIndex;

  ManagerAlterNewClientsSettings({super.key, required this.salesman, required this.client, required this.clientIndex});

  @override
  State<ManagerAlterNewClientsSettings> createState() => _ManagerAlterNewClientsSettingsState();
}

class _ManagerAlterNewClientsSettingsState extends State<ManagerAlterNewClientsSettings> {

  TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController locationController = TextEditingController();

  TextEditingController detailsController = TextEditingController();
  late String salesmanId;
  TextEditingController storeNameController = TextEditingController();

  @override
  void initState() {

    nameController.text = widget.client.clientName!;
    numberController.text = widget.client.clientNumber!;
    locationController.text = widget.client.location!;

    detailsController.text = widget.client.details!;
    storeNameController.text = widget.client.storeName!;

    salesmanId = widget.client.salesmanId!;

    super.initState();
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
                text: Localization.translate('alter_clients_appBar'),
                cubit: cubit
              ),

              body: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(

                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                      [
                        Text(Localization.translate('client_name_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

                        defaultFormField(
                            controller: nameController,
                            keyboard: TextInputType.text,
                            label: Localization.translate('client_name_title'),
                            prefix: Icons.text_format_outlined,
                            contentPadding: 20,
                            validate: (value)
                            {
                              return null;
                            }
                        ),

                        const SizedBox(height: 20,),

                        Text(Localization.translate('client_salesman_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

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
                                  value: salesmanId,
                                  isDense: true,
                                  onChanged: (newValue)
                                  {
                                    setState(() {
                                      salesmanId=newValue!;
                                    });
                                  },

                                  items: cubit.salesmen?.salesmen?.map((value) {
                                    return DropdownMenuItem<String>(
                                      value: value?.salesmanId,
                                      child: Row(
                                        children: [
                                          Text(
                                            '${value?.name}',
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

                        const SizedBox(height: 20,),

                        Text(Localization.translate('client_number_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

                        defaultFormField(
                            controller: numberController,
                            keyboard: TextInputType.number,
                            label: Localization.translate('client_number_title'),
                            prefix: Icons.numbers_outlined,
                            contentPadding: 20,
                            validate: (value)
                            {
                              return null;
                            }
                        ),

                        const SizedBox(height: 20,),

                        Text(Localization.translate('client_location_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

                        defaultFormField(
                            controller: locationController,
                            keyboard: TextInputType.text,
                            label: Localization.translate('client_location_title'),
                            prefix: Icons.place_outlined,
                            contentPadding: 20,
                            validate: (value)
                            {
                              return null;
                            }
                        ),

                        const SizedBox(height: 20,),

                        Text(Localization.translate('client_details_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

                        defaultFormField(
                            controller: detailsController,
                            keyboard: TextInputType.text,
                            label: Localization.translate('client_details_title'),
                            prefix: Icons.list_alt_outlined,
                            contentPadding: 20,
                            validate: (value)
                            {
                              return null;
                            }
                        ),

                        const SizedBox(height: 20,),

                        Text(Localization.translate('client_storeName_title'), style: textStyleBuilder(),),

                        const SizedBox(height: 20,),

                        defaultFormField(
                            controller: storeNameController,
                            keyboard: TextInputType.text,
                            label: Localization.translate('client_storeName_title'),
                            prefix: Icons.store_outlined,
                            contentPadding: 20,
                            validate: (value)
                            {
                              return null;
                            }
                        ),

                        const SizedBox(height: 20,),

                        Center(
                          child: defaultButton(
                            title: Localization.translate('submit_button'),
                            color: cubit.isDarkTheme? defaultBoxDarkColor : defaultBoxColor,
                            textColor: cubit.isDarkTheme? defaultDarkFontColor : defaultFontColor,
                            onTap: ()
                            {
                              cubit.alterClient(
                                  widget.clientIndex,
                                  numberController.value.text,
                                  nameController.value.text,
                                  detailsController.value.text,
                                  locationController.value.text,
                                  storeNameController.value.text,
                                  salesmanId
                              );

                              Navigator.pop(context);
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
}
