import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager_app/services/state_managers/login_controller.dart';
import 'package:task_manager_app/ui/screens/bottom_nav_base_screen.dart';
import 'package:task_manager_app/ui/screens/email_verification_screen.dart';
import 'package:task_manager_app/ui/screens/sign_up_screen.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started With",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      TextFormField(
                        controller: _emailTEController,
                        decoration: const InputDecoration(hintText: 'Email'),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter valid email";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      TextFormField(
                        controller: _passwordTEController,
                        obscureText: true,
                        decoration: const InputDecoration(hintText: 'Password'),
                        validator: (String? value) {
                          if (value?.isEmpty ?? true) {
                            return "Enter Password";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      GetBuilder<LoginController>(builder: (loginController) {
                        return SizedBox(
                          width: double.infinity,
                          child: Visibility(
                            visible: (loginController.logInProgress == false),
                            replacement: const Center(
                              child: CircularProgressIndicator(),
                            ),
                            child: ElevatedButton(
                                onPressed: () {
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }
                                  loginController
                                      .logIn(_emailTEController.text.trim(),
                                          _passwordTEController.text)
                                      .then((result) {
                                    if (result == true) {
                                      Get.offAll(const BottomNavBaseScreen());
                                    } else {
                                      Get.snackbar("Failed",
                                          "Login Failed! Please Try again!");
                                    }
                                  });
                                },
                                child: const Icon(Icons.arrow_forward)),
                          ),
                        );
                      }),
                      const SizedBox(
                        height: 16,
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const EmailVerificationScreen(),
                              ),
                            );
                          },
                          child: const Center(
                            child: Text(
                              "Forgot Password",
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't Have an Account?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()),
                                    (route) => false);
                              },
                              child: const Text("Sign up"))
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
