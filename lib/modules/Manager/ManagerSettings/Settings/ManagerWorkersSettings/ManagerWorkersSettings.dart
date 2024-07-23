import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/models/WorkerDetailsModel/WorkerDetailsModel.dart';
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
      listener: (context,state)
      {
        if(state is AppGetWorkersLoadingState)
        {
          defaultToast(msg: Localization.translate('get_worker_details_toast'));
        }
      },
      builder: (context,state)
      {
        var cubit= AppCubit.get(context);
        return Directionality(

          textDirection: appDirectionality(),
          child: Scaffold(
            appBar: defaultAppBar(cubit: cubit, text: 'workers_settings_title'),

            body: ConditionalBuilder(
              condition: cubit.workers !=null,
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
                      cubit.workers=null;
                      cubit.getWorkers();
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
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, worker: cubit.workers?.workers?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.workers!.workers!.length,
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
                                  itemBuilder: (context,index)=>itemBuilder(cubit: cubit, context: context, worker: cubit.workers?.workers?[index]),
                                  separatorBuilder: (context,index)=> const SizedBox(height: 20,),
                                  itemCount: cubit.workers!.workers!.length,
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
        //Only get orders on click if it's empty, pagination happens by scroll in his page
        if(worker?.orders?.length == 0)
        {
          cubit.getNextWorkerOrdersManager(id: worker!.worker!.id!, nextPage: worker.pagination?.nextPage);
        }

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
            '${worker?.worker?.name?? 'Worker Name'} ${worker?.worker?.lastName?? 'Worker Last'}',
            style: textStyleBuilder(fontSize: 22, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
