import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:getaccess/FeedBack/AdminHome.dart';
import 'package:getaccess/FeedBack/AdminLogin.dart';
import 'package:getaccess/FeedBack/StartPage.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // Firebase.initializeApp(
  //
  // );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mbits Feedback System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
        useMaterial3: true,
      ),
      home: const StartPage(),
    );
  }
}
