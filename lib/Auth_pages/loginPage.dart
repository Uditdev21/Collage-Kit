import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collagekit/Auth_pages/registerPages/PresonalData.dart';
import 'package:collagekit/Home/HomePage.dart';
import 'package:collagekit/Home/verificationPage.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final Loginkey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController PasswordController = TextEditingController();
  bool isLoading = false;
  authServices services = authServices();
  String message = '0';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Log-in "),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            OrientationBuilder(
              builder: (context, orientation) {
                return Form(
                  key: Loginkey,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        const Text("Email"),
                        TextFormField(
                          controller: emailcontroller,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Email cannot be empty';
                            }
                            final pattern = r'^[^@\s]+@[^@\s]+\.[^@\s]+$';
                            final regex = RegExp(pattern);
                            if (!regex.hasMatch(value)) {
                              return 'Enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        const Text("Password"),
                        TextFormField(
                          controller: PasswordController,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Password cannot be empty';
                            }
                            if (value.length < 6) {
                              return "Password should be at least 6 characters long";
                            }
                            return null;
                          },
                        ),
                        TextButton(
                            onPressed: () async {
                              if (Loginkey.currentState!.validate()) {
                                // print('login function');
                                setState(() {
                                  isLoading = true;
                                });
                                try {
                                  await services.LoginUser(
                                      Email: emailcontroller.text,
                                      Password: PasswordController.text);
                                  if (services.CurrentUser!.emailVerified) {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) => Homepage()),
                                      (Route<dynamic> route) =>
                                          false, // Remove all existing routes
                                    );
                                  } else {
                                    Navigator.of(context).pushAndRemoveUntil(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              Verificationpage()),
                                      (Route<dynamic> route) =>
                                          false, // Remove all existing routes
                                    );
                                  }
                                } on FirebaseException catch (e) {
                                  if (e.code == 'invalid-credential') {
                                    message =
                                        'please enter the valied email and password .';
                                  }
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                } finally {
                                  setState(() {
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: Text('Login')),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          child: Text('Dont Have Account? Register now'),
                          onTap: () => Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PersonalData()),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
            if (isLoading)
              Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: LoadingAnimationWidget.bouncingBall(
                    color: Colors.white,
                    size: 200,
                  ),
                ),
              ),
          ],
        ));
  }
}
