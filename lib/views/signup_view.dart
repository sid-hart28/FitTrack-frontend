import 'package:fit_track/models/login_response_model.dart';
import 'package:fit_track/models/signup_request_model.dart';
import 'package:fit_track/models/user_profile_model.dart';
import 'package:fit_track/services/helper_functions.dart';
import 'package:fit_track/services/user_auth_service.dart';
import 'package:fit_track/utils/utils.dart';
import 'package:fit_track/views/home_view.dart';
import 'package:flutter/material.dart';
import 'package:loading_overlay/loading_overlay.dart';
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
  double weight = 70;
  double height = 180;
  bool isLoading = false;
  bool isPageLoading = false;

  static const pattern = r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";
  final regex = RegExp(pattern);

  final GlobalKey<FormState> _formkeysignup = GlobalKey<FormState>();
  TextEditingController nameEditingController = TextEditingController();
  TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
  TextEditingController weightEditingController = TextEditingController();
  TextEditingController heightEditingController = TextEditingController();

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
    SignupRequestModel signupRequestModel = SignupRequestModel(name: name, email: email, password: password, height: height, weight: weight, dob: DateTime(2001, 01, 01));
    print("ab- $signupRequestModel");
    final loginResponseModel = await userAuthService.registerUser(signupRequestModel);
    if(loginResponseModel!=null) {
      if (loginResponseModel.status == 0) {
        print(loginResponseModel.message);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userProfile', userProfileToJson(loginResponseModel.userProfile!));
        prefs.setBool('isLoggedIn', true);
        setState(() {
          isPageLoading = false;
        });
        showToast(loginResponseModel.message?? 'loggedIn', Colors.green);
        // Navigator.pop(context);
        await Navigator.pushReplacementNamed(context, '/home', arguments: loginResponseModel.userProfile);
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



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: TColor.white,
      body: LoadingOverlay(
        isLoading: isPageLoading,
        child: SingleChildScrollView(
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
                      icon: Icon(Icons.person_2_outlined),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      controller: emailEditingController,
                      hitText: "Email",
                      icon: Icon(Icons.email_outlined),
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
                    RoundTextField(
                      controller: weightEditingController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your weight.";
                        }
                        final double? weight = double.tryParse(value);
                        if (weight == null || weight <= 10 || weight >= 300) {
                          return "Please enter a valid weight between 10 and 300 kg.";
                        }
                        return null;
                      },
                      hitText: "Weight (kg)",
                      icon:  Icon(Icons.monitor_weight_outlined),
                    ),
                    SizedBox(
                      height: media.width * 0.04,
                    ),
                    RoundTextField(
                      controller: heightEditingController,
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter your height.";
                        }
                        final double? height = double.tryParse(value);
                        if (height == null || height <= 30 || height >= 300) {
                          return "Please enter a valid height between 30 and 300 cm.";
                        }
                        return null;
                      },
                      hitText: "Height (cm)",
                      icon:  Icon(Icons.height),
                    ),
                    SizedBox(
                      height: media.width * 0.3,
                    ),
                    RoundButton(
                      isLoading: isLoading,
                      title: "Get Started",
                      onPressed: () async {
                        if (_formkeysignup.currentState!.validate()) {
                          setState(() {
                            isPageLoading = true;
                            email = emailEditingController.text.trim();
                            password = passwordEditingController.text.trim();
                            name = nameEditingController.text.trim();
                            weight = double.parse(weightEditingController.text.trim());
                            height = double.parse(heightEditingController.text.trim());
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
