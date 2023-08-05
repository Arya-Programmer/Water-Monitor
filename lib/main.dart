import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home.dart';

void main() async {
  print('-- main');

  WidgetsFlutterBinding.ensureInitialized();
  print('-- WidgetsFlutterBinding.ensureInitialized');

  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD07kLsCitvGYWpNHH3qkqYX-W6FnXBO0g",
      authDomain: "homecontrol-85bc9.firebaseapp.com",
      databaseURL: "https://homecontrol-85bc9-default-rtdb.firebaseio.com",
      projectId: "homecontrol-85bc9",
      storageBucket: "homecontrol-85bc9.appspot.com",
      messagingSenderId: "716140131825",
      appId: "1:716140131825:web:48d2ef5cd7cb3c70f24050",
      measurementId: "G-0RBFNQKEKN"
    ),
  );
  print('-- main: Firebase.initializeApp');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ڕێژەی ئاو'),
    );
  }
}

