part of 'authentication.cubit.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

class AuthenticationInitial extends AuthenticationState {}

class Authenticated extends AuthenticationState {
  // final String authToken;
  final String lastTime;

  const Authenticated(this.lastTime);
  @override
  String toString() {
    return AppValues.authCubitMsg;
  }
}

class UnAuthTokenExpired extends AuthenticationState {
  @override
  String toString() {
    return AppValues.unAuthCubitMsg;
  }
}

class UnAuthUserLoggedOut extends AuthenticationState {}
