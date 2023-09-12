import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/utils/widgets/buttons/button_custom.dart';
import 'package:firebasecore/ui/utils/widgets/textfileds/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController(text: 'b@gmail.com');
    TextEditingController passwordController = TextEditingController(text: '123456');
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
                  await authService.signInWithEmailandPassword(emailController.text, passwordController.text);
                },
                title: 'Login'),
            10.height,
            AnimationButon(onPressed: authService.handleSignin, title: 'Login with Google')
          ],
        ).paddingAll(20),
      ),
    );
  }
}
 //TextButton(onPressed: authService.handleSignin, child: const Text('Sign in with Google'))