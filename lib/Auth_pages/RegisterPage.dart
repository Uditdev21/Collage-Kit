import 'package:collagekit/services/auth_services.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passcontroller = TextEditingController();
  TextEditingController DisplayNamecontroller = TextEditingController();
  TextEditingController Collagecontroller = TextEditingController();
  TextEditingController Semestercontroller = TextEditingController();
  TextEditingController testcontroller = TextEditingController();
  DateTime selectedDate = DateTime.now();
  late SingleValueDropDownController _cnt = SingleValueDropDownController();
  String initalValue = "abc";

  authServices services = authServices();
  @override
  void initState() {
    // TODO: implement initState
    _cnt == SingleValueDropDownController();
    super.initState();
  }

  @override
  void dispose() {
    emailcontroller.dispose();
    passcontroller.dispose();
    DisplayNamecontroller.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }

    final currentDate = DateTime.now();
    final ageLimitDate = currentDate.subtract(Duration(days: 18 * 365));
    final selectedDateTime = DateTime.parse(value);

    if (selectedDateTime.isAfter(ageLimitDate)) {
      return 'Must be at least 18 years old';
    }

    return null; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          final double height = MediaQuery.of(context).size.height;
          final double width = MediaQuery.of(context).size.width;
          final Textsize = width * 0.3;
          return ListView(children: [
            Form(
              key: formKey,
              child: Center(
                child: Column(
                  children: [
                    Text("User Name"),
                    TextFormField(
                      controller: DisplayNamecontroller,
                      validator: (value) {
                        if (value!.length <= 4) {
                          return "password sould be at least of 4 letters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("collage"),
                    TextFormField(
                      controller: Collagecontroller,
                      validator: (value) {
                        if (value!.length <= 4) {
                          return "password sould be at least of 4 letters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    DropDownTextField(
                      controller: _cnt,
                      searchKeyboardType: TextInputType.multiline,
                      enableSearch: true,
                      dropDownItemCount: 8,
                      dropDownList: [
                        DropDownValueModel(name: 'test', value: 'value')
                      ],
                    ),
                    Text("semester"),
                    TextFormField(
                      controller: Semestercontroller,
                      // validator: (value) {
                      //   if (value!.length <= 4) {
                      //     return "password sould be at least of 4 letters";
                      //   }
                      //   return null;
                      // },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Date of Birth',
                        hintText: 'Select your DOB',
                      ),
                      readOnly: true,
                      controller: TextEditingController(
                        text: selectedDate.toLocal().toString().split(' ')[0],
                      ),
                      validator: _validateDate,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Email"),
                    TextFormField(
                      controller: emailcontroller,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        Pattern pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = new RegExp(pattern.toString());
                        if (!regex.hasMatch(value!))
                          return 'Enter a valid email address';
                        else
                          return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Password"),
                    TextFormField(
                      controller: passcontroller,
                      validator: (value) {
                        if (value!.length <= 6) {
                          return "password sould be at least of 6 letters";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              print(emailcontroller.text);
                              print(passcontroller.text);
                              print(DisplayNamecontroller.text);
                              print(selectedDate.toLocal());
                              print(Collagecontroller.text);
                              print('${int.parse(Semestercontroller.text)}');

                              print('${_cnt.dropDownValue!.name}');

                              // try {
                              //   await services.registerUser(
                              //     Email: emailcontroller.text,
                              //     Password: passcontroller.text,
                              //     displayName: DisplayNamecontroller.text,
                              //     DOB: selectedDate.toLocal(),
                              //     Collage: Collagecontroller.text,
                              //     Semester: int.parse(Semestercontroller.text),
                              //   );
                              //   Navigator.pushReplacement(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => homePage()),
                              //   );
                              // } on FirebaseException catch (e) {
                              //   debugPrint('${e.code}');
                              //   String message = 'debug';
                              //   if (e.code == 'email-already-in-use') {
                              //     message = 'email is already registred';
                              //   }
                              //   ScaffoldMessenger.of(context).showSnackBar(
                              //     SnackBar(content: Text(message)),
                              //   );
                              // }
                            }
                          },
                          child: Text("register")),
                    )
                  ],
                ),
              ),
            ),
          ]);
        },
      ),
    );
  }
}
