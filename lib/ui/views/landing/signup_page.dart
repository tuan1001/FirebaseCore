import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/utils/widgets/buttons/button_custom.dart';
import 'package:firebasecore/ui/utils/widgets/textfileds/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    AuthService authService = AuthService();
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFieldCus(
              controller: emailController,
              hintText: 'Email',
            ),
            TextFieldCus(
              controller: passwordController,
              hintText: 'Password',
            ),
            20.height,
            AnimationButon(
                onPressed: () async {
                  await authService.signUpWithEmailandPassword(emailController.text, passwordController.text);
                },
                title: 'Signup'),
            10.height,
          ],
        ).paddingAll(20),
      ),
    );
  }
}
 //TextButton(onPressed: authService.handleSignin, child: const Text('Sign in with Google'))