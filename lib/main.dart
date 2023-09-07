import 'package:cable_record/Screens/home.dart';
import 'package:cable_record/Screens/signin.dart';
import 'package:cable_record/Screens/signup.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
    apiKey: "AIzaSyCO02wq9Vk14QpE3p5G2CLnV3MGw0QESHA",
    appId: "1:858844873233:web:a84074e7b66836ca38e7b0",
    messagingSenderId: "858844873233",
    projectId: "telly-box",
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomeScreen());
  }
}
