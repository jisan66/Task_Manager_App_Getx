import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:task_manager_app/app.dart';
import 'package:task_manager_app/services/auth_utility.dart';
import 'package:task_manager_app/services/network_response.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';

class NetworkCaller {
  Future<NetworkResponse> getRequest(String url) async {
    Response response = await get(Uri.parse(url),
        headers: {'token': AuthUtility.userinfo.token.toString()});
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        return NetworkResponse(true, response.statusCode, decodedResponse);
      } else if (response.statusCode == 401) {
        gotoLogin();
      } else {
        return NetworkResponse(false, response.statusCode, decodedResponse);
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(false, -1, null);
  }

  Future<NetworkResponse> postRequest(String url, Map<String, dynamic> body,
      {bool isLogin = false}) async {
    Response response = await post(Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "token": AuthUtility.userinfo.token.toString()
        },
        body: jsonEncode(body));
    Map<String, dynamic> decodedResponse = jsonDecode(response.body);

    try {
      if (response.statusCode == 200) {
        return NetworkResponse(true, response.statusCode, decodedResponse);
      } else if (response.statusCode == 401) {
        if (isLogin == false) {
          gotoLogin();
        }
      } else {
        return NetworkResponse(false, response.statusCode, decodedResponse);
      }
    } catch (e) {
      log(e.toString());
    }
    return NetworkResponse(false, -1, null);
  }

  Future<void> gotoLogin() async {
    AuthUtility.clearUserInfo();
    Navigator.pushAndRemoveUntil(
        TaskManagerApp.globalKey.currentContext!,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (route) => false);
  }
}
