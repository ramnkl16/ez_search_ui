import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_messages.dart';
import 'package:ez_search_ui/constants/app_values.dart';
import 'package:ez_search_ui/exceptions/custom_exception.model.dart';
import 'package:ez_search_ui/helper/utilfunc.dart';
import 'package:ez_search_ui/modules/login/login.repo.dart';
import 'package:ez_search_ui/modules/login/login.reponse.model.dart';
import 'package:ez_search_ui/modules/login/login.request.model.dart';

part 'login.logic.state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(
    this.loginRepository,
  ) : super(LoginInitial());

  final LoginRepository loginRepository;

  Future<void> loginUser(LoginRequest loginRequest) async {
    emit(LoginLoading());
    try {
      LoginResponse loginResponse =
          await loginRepository.authenticateUser(loginRequest);
      SharedPreferences sharedPrefs = await SharedPreferences.getInstance();
      UtilFunc.setConnection("default", loginRequest.connString);
      await sharedPrefs.setString(
          ApiValues.authTokenHeader, loginResponse.authToken);
      emit(LoginSuccess(loginResponse: loginResponse));
    } on CustomException catch (e, s) {
      print('Error: $e');
      print("STACK TRACE: $s");
      emit(LoginFailure(errorMsg: e.toString(), errorCode: e.statusCode));
    } on SocketException catch (e, s) {
      //TODO: Handling socket exception
      print('Error: $e');
      print("STACK TRACE: $s");
      emit(const LoginFailure(
          errorMsg: AppMessages.noInternetMsg, errorCode: 4));
    } catch (e, s) {
      print('Error: $e');
      print("STACK TRACE: $s");
      emit(const LoginFailure(
          errorCode: AppValues.unknowErrorCode,
          errorMsg: AppMessages.unknownErrMsg));
    }
  }
}
