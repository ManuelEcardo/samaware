import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/LoginModel/LoginModel.dart';
import '../../../shared/network/end_points.dart';
import '../../../shared/network/remote/main_dio_helper.dart';
import 'loginStates.dart';

class LoginCubit extends Cubit<LoginStates>
{
  LoginCubit(): super(LoginInitialState());

  static LoginCubit get(context) =>BlocProvider.of(context);

  bool isPassVisible=true;

  void changePassVisibility()
  {
    isPassVisible=!isPassVisible;
    emit(LoginChangePassVisibilityState());
  }

  LoginModel? loginModel;
  void userLogin(String email, String password)
  {
    print('in User login ...');

    emit(LoginLoadingState());

    MainDioHelper.postData(
      url: login,
      isStatusCheck: true,
      data:
      {
        'email':email,
        'password':password,
      },
    ).then((value)
    {
      print('Got Login Data, ${value.data}');

       loginModel=LoginModel.fromJson(value.data);
      // AppCubit().getUserData(loginModel?.token);

      emit(LoginSuccessState(loginModel!));

    }).catchError((error)
    {
      print('ERROR WHILE LOGGING IN, ${error.toString()}');
      
      emit(LoginErrorState(error.toString()));
    });
  }
}