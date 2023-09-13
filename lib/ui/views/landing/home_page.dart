import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/views/chat/add_member_page.dart';
import 'package:firebasecore/ui/views/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    AuthService authService = AuthService();

    List<Map<String, dynamic>> membersList = [];
    return Scaffold(
        appBar: AppBar(
          actions: [IconButton(onPressed: authService.handleSignout, icon: const Icon(Icons.logout))],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => AddMemberPage(
                  membersList: membersList,
                ));
          },
          child: const Icon(Icons.group_add),
        ),
        body: _buildUserList());
  }

  _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
          );
        }));
  }

  _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    if (FirebaseAuth.instance.currentUser!.email != data['email']) {
      return ListTile(
        title: Text(data['email']),
        onTap: () {
          Get.to(() => ChatPage(
                receiverUserEmail: data['email'],
                receiverUserUid: data['uid'],
              ));
        },
      );
    } else {
      return Container();
    }
  }
}
