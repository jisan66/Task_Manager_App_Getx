import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager_app/services/model/login_model.dart';

class AuthUtility{
  AuthUtility._();

  static LoginModel userinfo = LoginModel();

  static Future<void> saveUserInfo(LoginModel model)async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("user-data", jsonEncode(model.toJson()));
    userinfo = model;
  }

  static Future<LoginModel> getUserInfo()async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String value = prefs.getString("user-data")!;
    return LoginModel.fromJson(jsonDecode(value));
  }

  static Future<void> clearUserInfo() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }

  static Future<bool> checkIfLoggedIn() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLogin = prefs.containsKey("user-data");
    if(isLogin){
    userinfo =  await getUserInfo();
    }
    return isLogin;
  }

}