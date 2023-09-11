import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/views/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
        child: ListTile(
          title: Text(FirebaseAuth.instance.currentUser!.email.toString()),
          onTap: () {
            Get.to(() => ChatPage(
                  receiverUserEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                  receiverUserUid: FirebaseAuth.instance.currentUser!.uid.toString(),
                ));
          },
        ),

        // Text(FirebaseAuth.instance.currentUser!.email.toString()

        // ),
      ),
    );
  }
}
