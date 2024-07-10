import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class PriceSetterSettings extends StatelessWidget {
  const PriceSetterSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit,AppStates>(
      listener: (context,state){},
      builder: (context,state)
      {
        var cubit=AppCubit.get(context);

        return SingleChildScrollView(
          child: Center(
            child: Text('Home'),
          ),
        );
      },

    );
  }
}
