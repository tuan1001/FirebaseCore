import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/service/auth_service.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();
    return Scaffold(
      appBar: AppBar(
        actions: [IconButton(onPressed: authService.handleSignout, icon: const Icon(Icons.logout))],
      ),
      body: Center(
        child: Text(FirebaseAuth.instance.currentUser!.email.toString()),
      ),
    );
  }
}
