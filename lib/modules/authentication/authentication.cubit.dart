import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ez_search_ui/constants/api_values.dart';
import 'package:ez_search_ui/constants/app_values.dart';

part 'authentication.state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(AuthenticationInitial());

  Future<void> checkAuthenticationStatus() async {
    // emit(Authentica)
    var prefs = await SharedPreferences.getInstance();
    String? tokenTime = prefs.getString(ApiValues.authTokenTime);
    // String? token = prefs.getString(ApiValues.authTokenHeader);
    // print("print token Time $tokenTime");
    //var authSer = getIt<AuthService>();
    if (tokenTime != null) {
      DateTime dateTime = DateTime.parse(tokenTime);
      var diff = DateTime.now().difference(dateTime);
      if (diff.inMinutes <= 24 * 60 * 60) {
        // return value;
        //authService.authenticated = true;
        //MyApp.of(context).authService.authenticated = true;

        emit(Authenticated(tokenTime));
      }
    }
    //authService.authenticated = false;
    emit(UnAuthTokenExpired());
  }

  void emitUnAuthTokenExpired() {
    //authService.authenticated = false;
    emit(UnAuthTokenExpired());
  }

  void emitAuthenticated(String time) {
    // authService.authenticated = true;
    emit(Authenticated(time));
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    //print('Authentication fromJson ' + json.toString());
    // TODO: implement fromJson
    // throw UnimplementedError();
    if (json[ApiValues.authTokenTime] != null) {
      // DateTime lastAccessTime = DateTime.parse(json[ApiValues.authTokenTime]);
      // if (DateTime.now().difference(lastAccessTime).inMinutes <= 29) {

      // authService.authenticated = true;
      //isAuthenticated = true;
      return Authenticated(ApiValues.authTokenTime);
      // }
    }
    return null;
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    // TODO: implement toJson
    // throw UnimplementedError();
    if (state is Authenticated) {
      return {ApiValues.authTokenTime: state.lastTime};
    }
  }
}
