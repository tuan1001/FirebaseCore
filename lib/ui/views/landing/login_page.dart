import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/utils/widgets/buttons/button_custom.dart';
import 'package:firebasecore/ui/utils/widgets/textfileds/textfield_custom.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController(text: 'b@gmail.com');
  TextEditingController passwordController = TextEditingController(text: '123456');
  //AuthService authService = AuthService();
  void signIn() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailandPassword(emailController.text, passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
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
            AnimationButon(onPressed: signIn, title: 'Login'),
            10.height,
            //AnimationButon(onPressed: authService.handleSignin, title: 'Login with Google')
          ],
        ).paddingAll(20),
      ),
    );
  }
}
 //TextButton(onPressed: authService.handleSignin, child: const Text('Sign in with Google'))