import 'package:samaware_flutter/shared/components/Imports/default_imports.dart';

class InspectorHome extends StatelessWidget {
  const InspectorHome({super.key});

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
