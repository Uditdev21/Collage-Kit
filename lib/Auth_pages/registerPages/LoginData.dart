import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/Home/verificationPage.dart';
import 'package:collagekit/services/auth_services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Logindata extends StatefulWidget {
  final String username;
  final DateTime dob;
  final String CollageName;
  final String semester;

  Logindata(
      {super.key,
      required this.username,
      required this.dob,
      required this.CollageName,
      required this.semester});

  @override
  State<Logindata> createState() => _LogindataState();
}

class _LogindataState extends State<Logindata> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> _loginDataKey = GlobalKey<FormState>();

  String message = '0';
  bool isLoading = false;

  //services
  authServices services = authServices();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Information'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          OrientationBuilder(
            builder: (context, orientation) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _loginDataKey,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        const Text("Email"),
                        TextFormField(
                          controller: emailController,
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
                          controller: passwordController,
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
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () async {
                            if (_loginDataKey.currentState!.validate()) {
                              setState(() {
                                isLoading = true;
                              });
                              try {
                                await services.registerUser(
                                    Email: emailController.text,
                                    Password: passwordController.text,
                                    displayName: widget.username,
                                    DOB: widget.dob,
                                    Collage: widget.CollageName,
                                    Semester: int.parse(widget.semester));

                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => Verificationpage()),
                                  (Route<dynamic> route) =>
                                      false, // Remove all existing routes
                                );

                                // Handle success, navigate to another page if necessary
                              } on FirebaseException catch (e) {
                                debugPrint('${e.code}');
                                if (e.code == 'email-already-in-use') {
                                  message = 'email is already registred';
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(message)),
                                  );
                                }
                              } finally {
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            }
                          },
                          child: const Text("submit"),
                        ),
                        Expanded(child: SizedBox()),
                        GestureDetector(
                          child: Text('Back to login page'),
                          onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Loginpage()),
                            (Route<dynamic> route) =>
                                false, // Remove all existing routes
                          ),
                        )
                      ],
                    ),
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
      ),
    );
  }
}
