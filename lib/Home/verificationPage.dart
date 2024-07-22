import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class Verificationpage extends StatefulWidget {
  const Verificationpage({super.key});

  @override
  State<Verificationpage> createState() => _VerificationpageState();
}

class _VerificationpageState extends State<Verificationpage> {
  authServices services = authServices();
  String message = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onTap: () async {
                    try {
                      await services.singout();
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => Loginpage()),
                        (Route<dynamic> route) => false,
                      );
                    } catch (e) {}
                  },
                  child: Icon(Icons.logout)),
            )
          ],
        ),
        body: OrientationBuilder(builder: (context, orientation) {
          return Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                      'Please check your Email for verification || if already verified please user singout button at top right to go back to singin/Login Page'),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextButton(
                  onPressed: () async {
                    try {
                      await services.resendVerificationMail();
                    } on FirebaseException catch (e) {
                      if (e.code == 'too-many-requests') {
                        message = 'aready send please wait to try again';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(message)),
                        );
                      }
                    } finally {
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Loginpage()));
                    }
                  },
                  child: Text('resend Verificaton Email'))
            ],
          );
        }));
  }
}
