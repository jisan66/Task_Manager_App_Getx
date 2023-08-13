import 'package:flutter/material.dart';
import 'package:task_manager_app/ui/screens/login_screen.dart';
import 'package:task_manager_app/ui/widgets/screen_background.dart';
import '../../services/network_caller.dart';
import '../../services/network_response.dart';
import '../../services/utils/urls.dart';

class SetPasswordScreen extends StatefulWidget {
  final email, otp;
  const SetPasswordScreen({Key? key, this.email, this.otp}) : super(key: key);

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTEController = TextEditingController();
  final TextEditingController _confirmPasswordTEController = TextEditingController();
  bool setPasswordInProgress = false;

  Future<void> resetPassword() async {
    setPasswordInProgress = true;
    if (mounted) {
      setState(() {});
    }

    final Map<String, dynamic> requestBody ={

        "email":widget.email,
        "OTP":widget.otp,
        "password":_passwordTEController.text

    };
    final NetworkResponse response = await NetworkCaller()
        .postRequest(Urls.resetPassword, requestBody);
    setPasswordInProgress = false;
    if (mounted) {
      setState(() {});
    }
    if (response.isSuccess) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Updated Successfully!")));
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=>const LoginScreen()), (route) => false);
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password Update Failed!")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScreenBackground(
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
                      "Set new password",
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    TextFormField(
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: 'Password'),
                      validator: (String? value)
                      {
                        if(value?.isEmpty ?? true)
                          {
                            return "Enter New Password";
                          }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      controller: _confirmPasswordTEController,
                      decoration: const InputDecoration(hintText: 'Confirm Password'),
                        validator: (String? value)
                        {
                          if(value?.isEmpty ?? true)
                          {
                            return "Enter Confirm Password";
                          }
                          else if(value! != _passwordTEController.text)
                            {
                              return "Password doesn't match";
                            }
                          return null;
                        }
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            if(!_formKey.currentState!.validate())
                              {
                                return;
                              }
                            resetPassword();
                          },
                          child: const Icon(Icons.arrow_forward)),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Have an Account?"),
                        TextButton(onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()),
                                  (route) => false);
                        }, child: const Text("Sign in"))
                      ],
                    )
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
