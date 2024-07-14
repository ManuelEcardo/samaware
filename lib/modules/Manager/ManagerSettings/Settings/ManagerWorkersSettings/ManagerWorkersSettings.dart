import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/models/OrderModel/OrderModel.dart';
import 'package:samaware_flutter/models/WorkerDetailsModel/WorkerDetailsModel.dart';
import 'package:samaware_flutter/modules/Manager/ManagerOrderDetails/ManagerOrderDetails.dart';
import 'package:samaware_flutter/modules/Manager/ManagerSettings/Settings/ManagerWorkersSettings/WorkerDetailsPage.dart';
import 'package:samaware_flutter/shared/components/Localization/Localization.dart';
import 'package:samaware_flutter/shared/components/components.dart';
import 'package:samaware_flutter/shared/components/constants.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerWorkersSettings extends StatelessWidget {
  const ManagerWorkersSettings({super.key});

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
            appBar: defaultAppBar(cubit: cubit, text: 'workers_settings_title'),

            body: ConditionalBuilder(
              condition: cubit.workersDetailsModel !=null,
              builder: (context)=>Padding(
                padding: const EdgeInsets.all(24.0),
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(context).copyWith(
                    physics: const BouncingScrollPhysics(),
                    dragDevices: dragDevices,
                  ),
                  child: RefreshIndicator(
                    onRefresh: ()async
                    {
                      cubit.getWorkersDetails();
                    },
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
                              Align(
                                alignment: AlignmentDirectional.topStart,
                                child: Text(
                                  Localization.translate('workers_details_settings_title'),
                                  style: headlineTextStyleBuilder(),
                                ),
                              ),

                              const SizedBox(height: 25,),

                              Expanded(
                                child: ListView.separated(
                                  //physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, worker: cubit.workersDetailsModel?.workers?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.workersDetailsModel!.workers!.length,
                                ),
                              ),
                            ],
                          );
                        }
                        else
                        {
                          return SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:
                              [
                                Align(
                                  alignment: AlignmentDirectional.topStart,
                                  child: Text(
                                    Localization.translate('workers_details_settings_title'),
                                    style: headlineTextStyleBuilder(),
                                  ),
                                ),

                                const SizedBox(height: 25,),

                                ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, worker: cubit.workersDetailsModel?.workers?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.workersDetailsModel!.workers!.length,
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
              fallback: (context)=>Center(child: defaultProgressIndicator(context)),
            ),
          ),
        );
      }
    );
  }

  Widget itemBuilder({required AppCubit cubit, required BuildContext context, required WorkerWithDetailsModel? worker})
  {
    return defaultBox(
      cubit: cubit,
      highlightColor: cubit.isDarkTheme? defaultDarkColor.withOpacity(0.2) : defaultColor.withOpacity(0.2),
      onTap: ()
      {
        navigateTo(context, WorkerDetailsPage(worker: worker!,));
      },
      boxColor: null,
      borderColor: cubit.isDarkTheme? defaultSecondaryDarkColor : defaultSecondaryColor,
      manualBorderColor: true,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:
        [
          Text(
            worker?.worker?.name?? 'Worker Name',
            style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
          ),

          const SizedBox(width: 10,),

          Text(
            '|',
            style: textStyleBuilder(fontSize: 24, fontWeight: FontWeight.w700),
          ),

          const SizedBox(width: 10,),

          Text(
            "${worker?.orders?.length?? 'Total Orders'}",
            style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
