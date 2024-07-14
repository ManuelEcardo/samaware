import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:samaware_flutter/layout/cubit/cubit.dart';
import 'package:samaware_flutter/layout/cubit/states.dart';
import 'package:samaware_flutter/shared/components/components.dart';

class ManagerOrdersSettings extends StatelessWidget {
  const ManagerOrdersSettings({super.key});

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
              appBar: defaultAppBar(cubit: cubit, text: 'orders_settings_title'),

              body: SingleChildScrollView(

              ),
            ),
          );
        }
    );
  }
}
