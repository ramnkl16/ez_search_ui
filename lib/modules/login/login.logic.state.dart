part of 'login.logic.cubit.dart';

abstract class LoginState extends Equatable {
  const LoginState();

  @override
  List<Object> get props => [];
}

class LoginInitial extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginResponse loginResponse;
  const LoginSuccess({
    required this.loginResponse,
  });

  @override
  List<Object> get props => [loginResponse];
}

class LoginLoading extends LoginState {}

class LoginFailure extends LoginState {
  final String errorMsg;
  final int errorCode;
  const LoginFailure({
    required this.errorMsg,
    required this.errorCode,
  });
}
