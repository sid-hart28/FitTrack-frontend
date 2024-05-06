// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:fit_track/models/login_request_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/services/alarm_service.dart';
import 'package:fit_track/services/helper_functions.dart';
import 'package:fit_track/services/sd_service.dart';
import 'package:fit_track/services/user_auth_service.dart';
import 'package:fit_track/views/testing_view.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loading_overlay/loading_overlay.dart';
// import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fit_track/services/background_service.dart';

import '../utils/colors.dart';
import '../utils/widgets/round_button.dart';
import '../utils/widgets/round_textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  String password = "";
  String email = "";
  static const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regex = RegExp(pattern);
  bool isLoading = false;
  bool isCheck = false;
  bool showPassword = false;
  final _formkey = GlobalKey<FormState>();
  bool isPageLoading = false;

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }


  // Future<void> requestPermissionsAndInitializeService() async {
  //   var status = await Permission.activityRecognition.request();
  //   // final alarmStatus = await Permission.scheduleExactAlarm.request();
  //   if (status.isGranted) {
  //     // Initialize the background service only if permissions are granted
  //     await initializeService();
  //     // await scheduleAlarm();
  //   } else {
  //     // Handle the case where permissions are not granted
  //     print("Permissions not granted");
  //   }
  // }
  Future<void> handleLogin() async {
    print("In handleLogin");
    UserAuthService userAuthService = UserAuthService();
    LoginRequestModel loginRequestModel = LoginRequestModel(
        email: email, password: password);
    print("ab- $loginRequestModel");
    final loginResponseModel = await userAuthService.loginUser(
        loginRequestModel);
    if (loginResponseModel != null) {
      if (loginResponseModel.status == 0) {
        print(loginResponseModel.message);
        // Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
            'userProfile', userProfileToJson(loginResponseModel.userProfile!));
        prefs.setBool('isLoggedIn', true);
        setState(() {
          isPageLoading = false;
        });
        showToast(loginResponseModel.message?? 'loggedIn', Colors.green);
        // await requestPermissionsAndInitializeService();
        await Navigator.pushReplacementNamed(
            context, '/home', arguments: loginResponseModel.userProfile);
      }
      else {
        print(
            loginResponseModel.message);
        setState(() {
          isPageLoading = false;
        });
        showToast(loginResponseModel.message ?? 'retry again', Colors.yellow);
      }
    } else {
      print("network error");
      setState(() {
        isPageLoading = false;
      });
      showToast("network error", Colors.red);
    }
  }

  String text = "Stop Service";

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: LoadingOverlay(
        isLoading: isPageLoading,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              height: media.height * 0.9,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Hey there,",
                      style: TextStyle(color: TColor.gray, fontSize: 16),
                    ),
                    Text(
                      "Welcome Back",
                      style: TextStyle(
                          color: TColor.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                    // ElevatedButton(onPressed: () {
                    //   Navigator.push(
                    //     context,
                    //     MaterialPageRoute(builder: (context) => const TestingView()),
                    //   );
                    // },
                    //
                    //   child: const Text('Click'),),
                    //     ElevatedButton(onPressed: () {
                    //       FlutterBackgroundService().invoke('setAsForeground');
                    //     },
                    //       child: const Text('Start Foreground'),),
                    //     ElevatedButton(onPressed: () {
                    //       FlutterBackgroundService().invoke('setAsBackground');
                    //     },
                    //       child: const Text('Start Background'),),
                    // ElevatedButton(
                    //   child: Text(text),
                    //   onPressed: () async {
                    //     final service = FlutterBackgroundService();
                    //     var isRunning = await service.isRunning();
                    //     if (isRunning) {
                    //       service.invoke("stopService");
                    //     } else {
                    //       service.startService();
                    //     }
                    //
                    //     if (!isRunning) {
                    //       text = 'Stop Service';
                    //     } else {
                    //       text = 'Start Service';
                    //     }
                    //     setState(() {});
                    //   },
                    // ),
                    //
                    SizedBox(
                      height: media.width * 0.05,
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      controller: txtEmail,
                      hitText: "Email",
                      icon: Icon(Icons.email_outlined),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your email.";
                        } else if (!regex.hasMatch(value)) {
                          return "Please enter a valid email";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your password.";
                        }
                        return null;
                      },
                      controller: txtPassword,
                      hitText: "Password",
                      icon: Icon(Icons.lock_outline_rounded),
                      obscureText: !showPassword,
                      rigtIcon: TextButton(
                        onPressed: () {
                          togglePasswordVisibility();
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 20,
                          height: 20,
                          child: !showPassword
                              ? Image.asset(
                            "assets/img/show_password.png",
                            width: 20,
                            height: 20,
                            fit: BoxFit.contain,
                            color: TColor.gray,
                          )
                              : Icon(
                            Icons.visibility,
                            color: TColor.primaryColor1,
                          ),
                        ),
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Padding(
                    //       padding: const EdgeInsets.only(top: 15),
                    //       child: Text(
                    //         "Forgot your password?",
                    //         style: TextStyle(
                    //             color: TColor.secondaryColor2,
                    //             fontSize: 12,
                    //             decoration: TextDecoration.underline),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    const Spacer(),
                    RoundButton(
                      title: "Login",
                      isLoading: isLoading,
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          setState(() {
                            isPageLoading = true;
                            email = txtEmail.text.trim();
                            password = txtPassword.text.trim();
                          });
                         await handleLogin();
                        }
                      },
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    Row(
                      // crossAxisAlignment: CrossAxisAlignment.,
                      children: [
                        Expanded(
                            child: Container(
                              height: 1,
                              color: TColor.gray.withOpacity(0.5),
                            )),
                        Text(
                          "  Or  ",
                          style: TextStyle(color: TColor.black, fontSize: 12),
                        ),
                        Expanded(
                            child: Container(
                              height: 1,
                              color: TColor.gray.withOpacity(0.5),
                            )),
                      ],
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         width: 50,
                    //         height: 50,
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //           color: TColor.white,
                    //           border: Border.all(
                    //             width: 1,
                    //             color: TColor.gray.withOpacity(0.4),
                    //           ),
                    //           borderRadius: BorderRadius.circular(15),
                    //         ),
                    //         child: Image.asset(
                    //           "assets/img/google.png",
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     ),
                    //     SizedBox(
                    //       width: media.width * 0.04,
                    //     ),
                    //     GestureDetector(
                    //       onTap: () {},
                    //       child: Container(
                    //         width: 50,
                    //         height: 50,
                    //         alignment: Alignment.center,
                    //         decoration: BoxDecoration(
                    //           color: TColor.white,
                    //           border: Border.all(
                    //             width: 1,
                    //             color: TColor.gray.withOpacity(0.4),
                    //           ),
                    //           borderRadius: BorderRadius.circular(15),
                    //         ),
                    //         child: Image.asset(
                    //           "assets/img/facebook.png",
                    //           width: 20,
                    //           height: 20,
                    //         ),
                    //       ),
                    //     )
                    //   ],
                    // ),
                    //
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    TextButton(
                      onPressed: () async {
                        await Navigator.pushReplacementNamed(context, '/signup');
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Don’t have an account yet? ",
                            style: TextStyle(
                              color: TColor.black,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "Signup",
                            style: TextStyle(
                                color: TColor.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}