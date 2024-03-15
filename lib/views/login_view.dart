import 'package:fit_track/models/login_request_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/services/user_auth_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  void togglePasswordVisibility() {
    setState(() {
      showPassword = !showPassword;
    });
  }

  void handleLogin() async{
    print("In handleLogin");
    UserAuthService userAuthService = UserAuthService();
    LoginRequestModel loginRequestModel = LoginRequestModel(email: email, password: password);
    print("ab- $loginRequestModel");
    final loginResponseModel = await userAuthService.loginUser(loginRequestModel);
    if(loginResponseModel!=null) {
      if (loginResponseModel.status == 0) {
        print(loginResponseModel.message);
        // Navigator.pop(context);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userProfile', userProfileToJson(loginResponseModel.userProfile!));
        prefs.setBool('isLoggedIn', true);
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
                  SizedBox(
                    height: media.width * 0.05,
                  ),
                  SizedBox(
                    height: media.width * 0.04,
                  ),
                  RoundTextField(
                    controller: txtEmail,
                    hitText: "Email",
                    icon: "assets/img/email.png",
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter your email.";
                      }else if(!regex.hasMatch(value)){
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
                          email = txtEmail.text.trim();
                          password = txtPassword.text.trim();
                        });
                        handleLogin();
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
                    onPressed: () async{
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
    );
  }
}
