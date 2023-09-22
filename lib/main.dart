// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecore/firebase_options.dart';
import 'package:firebasecore/service/auth_service.dart';
import 'package:firebasecore/ui/views/home/page1.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'routes/routes.dart';
import 'service/noti_service.dart';

import 'ui/views/landing/landing_page.dart';

/// The scopes required by this application.
final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: GetMaterialApp(
        debugShowCheckedModeBanner: false, title: 'Google Sign In', getPages: AppPages.routes, navigatorKey: navigatorKey, home: const Page1()),
  ));
}

/// The SignInDemo app.

