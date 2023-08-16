import 'package:get/get.dart';
import 'package:task_manager_app/services/network_response.dart';
import '../auth_utility.dart';
import '../model/login_model.dart';
import '../network_caller.dart';
import '../utils/urls.dart';

class LoginController extends GetxController {

  bool _logInProgress = false;
  bool get logInProgress => _logInProgress;

  Future<bool> logIn(String email, String password) async {

    update();
    Map<String, dynamic> loginBody = {"email": email, "password": password};
    _logInProgress = false;

    NetworkResponse response =
        await NetworkCaller().postRequest(Urls.login, loginBody, isLogin: true);

    _logInProgress = false;
    update();
    if (response.isSuccess) {
      LoginModel model = LoginModel.fromJson(response.body!);
      await AuthUtility.saveUserInfo(model);
      return true;
    } else {
      return false;
    }
  }
}
