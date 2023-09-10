import 'package:firebasecore/service/auth_service.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      body: Center(
        child: TextButton(onPressed: authService.handleSignin, child: const Text('Sign in with Google')),
      ),
    );
  }
}
