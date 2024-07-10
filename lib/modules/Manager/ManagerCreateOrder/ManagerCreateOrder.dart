import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';
import 'package:samaware_flutter/shared/styles/colors.dart';

class ManagerCreateOrder extends StatelessWidget {
  const ManagerCreateOrder({super.key});

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

            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsetsDirectional.all(24.0),
                child: Column(
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
        );
      },
    );
  }
}
