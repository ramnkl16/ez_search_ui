import 'package:auto_route/auto_route.dart';
import 'package:ez_search_ui/main.dart';
import 'package:ez_search_ui/services/serviceLocator.dart';
import 'package:ez_search_ui/services/storageservice/storageservice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ez_search_ui/common/global.dart';
import 'package:ez_search_ui/constants/api_endpoints.dart';
import 'package:ez_search_ui/constants/app_values.dart';

import 'package:ez_search_ui/helper/UIHelper.dart';
import 'package:ez_search_ui/helper/utilfunc.dart';
import 'package:ez_search_ui/modules/authentication/authentication.cubit.dart';
import 'package:ez_search_ui/modules/login/login.request.model.dart';
import 'package:ez_search_ui/router/appRouter.gr.dart';

import 'login.logic.cubit.dart';

class LoginPage extends StatefulWidget {
  Function(bool)? onLoginSuccess;
  String? redirectRoute;

  LoginPage({Key? key, this.onLoginSuccess, this.redirectRoute})
      : super(key: key);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController domainCtrl;
  late TextEditingController emailOrMobCtrl;
  late TextEditingController pwdCtrl;
  late TextEditingController connCtrl;

  @override
  void initState() {
    domainCtrl = TextEditingController();
    emailOrMobCtrl = TextEditingController();
    pwdCtrl = TextEditingController();
    connCtrl = TextEditingController(text: apiConn); //apiConn global variable

    domainCtrl.text = 'platform';
    emailOrMobCtrl.text = 'admin@gost.com';
    pwdCtrl.text = 'welcome@123';

    //var prefs = getIt<StorageService>();
    //apiConn = await prefs.getApiActiveConn();

    // domainCtrl.text = 'PLATFORM';
    // emailOrMobCtrl.text = 'platformadmin@gmail.com';
    // pwdCtrl.text = 'password1';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Global.isMobileResolution = (MediaQuery.of(context).size.width) < 768;
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: Colors.white,
                  elevation: 5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30,
                      ),
                      Text(
                        'Welcome to Gost Search! ',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text('Login',
                          textAlign: TextAlign.left,
                          style: Theme.of(context).textTheme.bodyText1),
                      SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: AppValues.loginWidgetWidth,
                          child: TextField(
                            controller: domainCtrl,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Namspace Code'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: AppValues.loginWidgetWidth,
                          child: TextField(
                            controller: emailOrMobCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Enter Email or Mobile'),
                          ),
                        ),
                      ),
                      BlocListener<LoginCubit, LoginState>(
                        listener: (context, state) {
                          if (state is LoginSuccess) {
                            Global.loadInitialMeta();
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                    "Success! Auth Token: ${state.loginResponse.authToken}")));
                            BlocProvider.of<AuthenticationCubit>(context)
                                .emitAuthenticated(DateTime.now().toString());

                            if (widget.onLoginSuccess != null) {
                              widget.onLoginSuccess!(true);
                            } else {
                              // var a = AutoRouter.of(context);
                              //var path = a.topMatch.path;
                              // a.stackData.first
                              //var par = AutoRouter.of(context).parent();
                              // AutoRouter.of(context).pop();
                              print("widget.redirectRoute");
                              print(widget.redirectRoute);
                              if (widget.redirectRoute != null) {
                                AutoRouter.of(context)
                                    .replaceNamed(widget.redirectRoute!);
                              } else {
                                //SearchRoute();
                                HomeRoute();
                              }
                              // AutoRouter.declarative(routes: routes)
                              // .replace(CustomBookingTableRoute());
                            }
                          } else if (state is LoginFailure) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.errorMsg)));
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            width: AppValues.loginWidgetWidth,
                            child: TextField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: pwdCtrl,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Enter password'),
                            ),
                          ),
                        ),
                      ),
                      // if (apiConn == null)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: AppValues.loginWidgetWidth,
                          child: TextField(
                            controller: connCtrl,
                            keyboardType: TextInputType.emailAddress,
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Api Connection string'),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      BlocBuilder<LoginCubit, LoginState>(
                        builder: (context, state) {
                          if (state is LoginLoading) {
                            // BlocProvider.of<AuthenticationCubit>(context).emitLoadingStatus();
                            return CircularProgressIndicator();
                          } else if (state is LoginFailure) {
                            return Column(
                              children: [
                                buildSignInButton(context),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  width: 370,
                                  color: Colors.amber[50],
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'Error: ' + state.errorMsg,
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                )
                              ],
                            );
                          }
                          return Column(
                            children: [
                              buildSignInButton(context),
                              SizedBox(
                                height: 20,
                              )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  MaterialButton buildSignInButton(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        BlocProvider.of<LoginCubit>(context).loginUser(LoginRequest(
          emailOrMobile: emailOrMobCtrl.text,
          password: pwdCtrl.text,
          nsCode: domainCtrl.text,
          connString: connCtrl.text,
        ));
      },
      child: UIHelper.btnDecoration(
          'Sign in', MediaQuery.of(context).size.width,
          toolTipMsg: ""),
    );
  }
}
