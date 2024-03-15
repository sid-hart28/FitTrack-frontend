import 'package:fit_track/models/login_request_model.dart';
import 'package:fit_track/models/login_response_model.dart';
import 'package:fit_track/models/signup_request_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// 10.0.2.2:8080
// 192.168.240.128
class UserAuthService {
  static const baseUrl = 'http://192.168.240.128:8080/api/auth/';

  Future<LoginResponseModel?> registerUser(SignupRequestModel signupRequestModel) async{
    print("In UserAuth RegisterUser");
    print(signupRequestModelToJson(signupRequestModel));
    var client = http.Client();
    var uri = Uri.parse('${baseUrl}register');
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var response = await client.post(
          uri,
          body: signupRequestModelToJson(signupRequestModel),
        headers: headers
      );
      if(response.statusCode == 200) {
        print('successful reg');
        return loginResponseModelFromJson(utf8.decode(response.bodyBytes));
      }
      else {
        print(response.reasonPhrase);
      }
    } catch(e) {
      print(e);
      client.close();
    }
    return null;
  }

  
  Future<LoginResponseModel?> loginUser(LoginRequestModel loginRequestModel) async{
    print("In UserAuth LoginUser");
    print(loginRequestModelToJson(loginRequestModel));
    var client = http.Client();
    var uri = Uri.parse('${baseUrl}login');
    try {
      var headers = {
        'Content-Type': 'application/json'
      };
      var response = await client.post(
          uri,
          body: loginRequestModelToJson(loginRequestModel),
        headers: headers,
      );
      if(response.statusCode == 200) {
        print('successful login');
        return loginResponseModelFromJson(utf8.decode(response.bodyBytes));
      }
      else {
        print(response.reasonPhrase);
      }
    } catch(e) {
      print(e);
      client.close();
    }
    return null;
  }

}