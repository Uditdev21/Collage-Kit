import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/Home/HomePage.dart';
import 'package:collagekit/Home/verificationPage.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  authServices authservices = authServices();
  bool isLogin = false;
  bool isVerified = false;
  User? user;

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      if (user!.emailVerified) {
        setState(() {
          isLogin = true;
          isVerified = true;
        });
      } else {
        setState(() {
          isLogin = true;
          isVerified = false;
        });
      }
    } else {
      setState(() {
        isLogin = false;
        isVerified = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'Collage Kit',
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: Color.fromARGB(255, 247, 3, 3)),
        useMaterial3: true,
      ),
      home: isLogin
          ? (isVerified ? Homepage() : Verificationpage())
          : Loginpage(),
    );
  }
}
