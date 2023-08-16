import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:task_manager_app/services/auth_utility.dart';
import 'package:task_manager_app/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager_app/ui/utils/assets_utils.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import 'login_screen.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToLogin();
  }

  Future<void> navigateToLogin() async {
    Future.delayed(const Duration(seconds: 5)).then((_) async {
      final bool isLoggedin = await AuthUtility.checkIfLoggedIn();
      if (mounted) {
        Get.offAll(() => isLoggedin
            ? const BottomNavBaseScreen()
            : const LoginScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SvgPicture.asset(AssetsUtils.logoSVG, fit: BoxFit.scaleDown),
        ),
      ),
    );
  }
}
