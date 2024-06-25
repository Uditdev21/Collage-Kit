import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/Auth_pages/registerPages/collageData.dart';
import 'package:flutter/material.dart';

class PersonalData extends StatefulWidget {
  const PersonalData({super.key});

  @override
  State<PersonalData> createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  // Initial keys and controllers
  final GlobalKey<FormState> _personalDataKey = GlobalKey<FormState>();
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  // Select date function
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = _selectedDate.toLocal().toString().split(' ')[0];
      });
    }
  }

  String? _validateDate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a date';
    }

    final currentDate = DateTime.now();
    final ageLimitDate = currentDate.subtract(const Duration(days: 16 * 365));
    final selectedDateTime = DateTime.tryParse(value);

    if (selectedDateTime == null) {
      return 'Invalid date format';
    }

    if (selectedDateTime.isAfter(ageLimitDate)) {
      return 'Must be at least 16 years old';
    }
    return null; // Validation passed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Data'),
        centerTitle: true,
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Form(
            key: _personalDataKey,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Username'),
                  TextFormField(
                    controller: _displayNameController,
                    validator: (value) {
                      if (value == null || value.length < 4) {
                        return 'Username should be at least 4 letters long';
                      }
                      return null;
                    },
                  ),
                  const Text('Date of Birth'),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Date of Birth',
                      hintText: 'Select your DOB',
                    ),
                    readOnly: true,
                    controller: _dateController,
                    validator: _validateDate,
                    onTap: () => _selectDate(context),
                  ),
                  TextButton(
                    onPressed: () {
                      if (_personalDataKey.currentState!.validate()) {
                        print(_selectedDate);
                        print(_displayNameController.text);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Collagedata(
                                  username: _displayNameController.text,
                                  dob: _selectedDate)),
                        );
                      }
                    },
                    child: const Text("Submit"),
                  ),
                  Expanded(child: SizedBox()),
                  GestureDetector(
                      child: Text('Back to login page'),
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => Loginpage()),
                            (Route<dynamic> route) =>
                                false, // Remove all existing routes
                          ))
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
