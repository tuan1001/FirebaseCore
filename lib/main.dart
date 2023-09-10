// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: avoid_print

import 'package:firebase_core/firebase_core.dart';
import 'package:firebasecore/firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ui/landing_page.dart';

/// The scopes required by this application.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    const MaterialApp(
      title: 'Google Sign In',
      home: LandingPage(),
    ),
  );
}

/// The SignInDemo app.

