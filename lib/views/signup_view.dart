import 'package:fit_track/models/login_response_model.dart';
import 'package:fit_track/models/signup_request_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/services/user_auth_service.dart';
import 'package:fit_track/utils/utils.dart';
import 'package:fit_track/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/colors.dart';
import '../utils/widgets/round_button.dart';
import '../utils/widgets/round_textfield.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String name = "";
  String email = "";
  String password = "";
  bool isLoading = false;

  static const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regex = RegExp(pattern);

  final GlobalKey<FormState> _formkeysignup = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();

  bool isCheck = false;
  bool showPassword = false;
  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void handleGetStarted() async{
    print("In handleGetStarted");
    UserAuthService userAuthService = UserAuthService();
    SignupRequestModel signupRequestModel = SignupRequestModel(name: name, email: email, password: password, height: 180.0, weight: 70.0, dob: DateTime(2001, 01, 01));
    print("ab- $signupRequestModel");
    final loginResponseModel = await userAuthService.registerUser(signupRequestModel);
    if(loginResponseModel!=null) {
      if (loginResponseModel.status == 0) {
        print(loginResponseModel.message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userProfile', userProfileToJson(loginResponseModel.userProfile!));
        prefs.setBool('isLoggedIn', true);
        // Navigator.pop(context);
        await Navigator.pushReplacementNamed(context, '/home', arguments: loginResponseModel.userProfile);
      }
      else {
        print(
            loginResponseModel.message);
      }
    } else {
      print("network error");
    }
  }



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formkeysignup,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Hey there,",
                    style: TextStyle(color: TColor.gray, fontSize: 16),
                  ),
                  Text(
                    "Create an Account",
                    style: TextStyle(
                        color: TColor.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  RoundTextField(
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please, enter your full name";
                      }
                      return null;
                    },
                    controller: nameEditingController,
                    hitText: "Full Name",
                    icon: "assets/img/user_text.png",
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    controller: emailEditingController,
                    hitText: "Email",
                    icon: "assets/img/email.png",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email";
                      }
                      else if(!regex.hasMatch(value)){
                        return "Please enter a valid email";
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    controller: passwordEditingController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your password.";
                      }
                      return null;
                    },
                    hitText: "Password",
                    icon: "assets/img/lock.png",
                    obscureText: !showPassword,
                    rigtIcon: TextButton(
                      onPressed: () {
                        togglePasswordVisibility();
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: 20,
                        height: 20,
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
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  // Row(
                  //   // crossAxisAlignment: CrossAxisAlignment.,
                  //   children: [
                  //     IconButton(
                  //       onPressed: () {
                  //         setState(() {
                  //           isCheck = !isCheck;
                  //         });
                  //       },
                  //       icon: Icon(
                  //         isCheck
                  //             ? Icons.check_box_outlined
                  //             : Icons.check_box_outline_blank_outlined,
                  //         color: isCheck ? TColor.primaryColor1 : TColor.gray,
                  //         size: 21,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       child: Padding(
                  //         padding: const EdgeInsets.only(top: 10),
                  //         child: RichText(
                  //           text: TextSpan(
                  //             // style: DefaultTextStyle.of(context).style,
                  //             children: <TextSpan>[
                  //               TextSpan(
                  //                 text: "By continuing you accept our ",
                  //                 style: TextStyle(
                  //                     color: TColor.gray,
                  //                     fontSize: 12,
                  //                     decoration: TextDecoration.none),
                  //               ),
                  //               TextSpan(
                  //                 text: "Privacy Policy",
                  //                 style: TextStyle(
                  //                     color: TColor.primaryColor1,
                  //                     fontSize: 12,
                  //                     decoration: TextDecoration.none),
                  //               ),
                  //               TextSpan(
                  //                 text: " and ",
                  //                 style: TextStyle(
                  //                     color: TColor.gray,
                  //                     fontSize: 12,
                  //                     decoration: TextDecoration.none),
                  //               ),
                  //               TextSpan(
                  //                 text: "Terms of Use",
                  //                 style: TextStyle(
                  //                     color: TColor.primaryColor1,
                  //                     fontSize: 12,
                  //                     decoration: TextDecoration.none),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       ),
                  //     )
                  //   ],
                  // ),
                  SizedBox(
                    height: media.width * 0.3,
                  ),
                  RoundButton(
                    isLoading: isLoading,
                    title: "Get Started",
                    onPressed: () async {
                      if (_formkeysignup.currentState!.validate()) {
                        setState(() {
                          email = emailEditingController.text.trim();
                          password = passwordEditingController.text.trim();
                          name = nameEditingController.text.trim();
                        });
                        handleGetStarted();
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
                  TextButton(
                    onPressed: () async{
                      await Navigator.pushReplacementNamed(context, '/login');
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Already have an account? ",
                          style: TextStyle(
                            color: TColor.black,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "Login",
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
    );
  }
}

void showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      dismissDirection: DismissDirection.up,
      behavior: SnackBarBehavior.floating,
      // margin: EdgeInsets.only(
      //     bottom: MediaQuery.of(context).size.width * 1.91,
      //     left: 20,
      //     right: 20),
      duration: const Duration(seconds: 1),
      backgroundColor: Colors.redAccent,
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    ),
  );
}
