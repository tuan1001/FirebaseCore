import 'package:cloud_firestore/cloud_firestore.dart';
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
        body: _buildUserList());
  }

  _buildUserList() {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          QuerySnapshot querySnapshot = snapshot.data as QuerySnapshot;
          return ListTile(
            title: Text(FirebaseAuth.instance.currentUser!.email.toString()),
            onTap: () {
              Get.to(() => ChatPage(
                    receiverUserEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                    receiverUserUid: FirebaseAuth.instance.currentUser!.uid.toString(),
                  ));
            },
          );

          //  ListView(
          //   children: snapshot.data!.docs.map((doc) => _buildUserListItem(doc)).toList(),
          // );
        }));
  }

  _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Get.to(() => ChatPage(
                receiverUserEmail: FirebaseAuth.instance.currentUser!.email.toString(),
                receiverUserUid: FirebaseAuth.instance.currentUser!.uid.toString(),
              ));
        },
      );
    }
  }
}
