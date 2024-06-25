import 'package:collagekit/Auth_pages/loginPage.dart';
import 'package:collagekit/Auth_pages/registerPages/LoginData.dart';
import 'package:collagekit/services/collage_services.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';

class Collagedata extends StatefulWidget {
  final String username;
  final DateTime dob;
  const Collagedata({super.key, required this.username, required this.dob});

  @override
  State<Collagedata> createState() => _CollagedataState();
}

class _CollagedataState extends State<Collagedata> {
  final GlobalKey<FormState> _collageDataKey = GlobalKey<FormState>();
  late SingleValueDropDownController _semesterController;
  late SingleValueDropDownController _collagenameController;
  late List<DropDownValueModel> _semlist;
  late List<DropDownValueModel> _collagenamesmodel;
  late List<String> _collagenames;
  bool _dataReady = false;
  CollageServices services = CollageServices();
  bool _collagedataready = false;

  @override
  void initState() {
    super.initState();
    _semesterController = SingleValueDropDownController();
    _collagenameController = SingleValueDropDownController();
    _initializeSemList();
    _initilizecollageList();
    // services.getCollagesNames();
  }

  void _initilizecollageList() async {
    _collagenames = await services.getCollagesNames();
    _collagenamesmodel = _collagenames.map((semester) {
      return DropDownValueModel(name: semester, value: semester);
    }).toList();
    print(_collagenamesmodel);
    setState(() {
      _collagedataready = true;
    });
  }

  void _initializeSemList() {
    List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
    _semlist = semesters.map((semester) {
      return DropDownValueModel(name: semester, value: semester);
    }).toList();
    setState(() {
      _dataReady = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Education"),
        centerTitle: true,
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _collageDataKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text("Collage"),
                  DropDownTextField(
                    controller: _collagenameController,
                    enableSearch: true,
                    dropDownList: _collagedataready
                        ? _collagenamesmodel
                        : [], // Provide your list of collages here
                  ),
                  const SizedBox(height: 16),
                  const Text('Semester'),
                  DropDownTextField(
                    enableSearch: true,
                    controller: _semesterController,
                    dropDownList: _dataReady ? _semlist : [],
                  ),
                  TextButton(
                      onPressed: () {
                        print(_semesterController.dropDownValue!.value);
                        print(_collagenameController.dropDownValue!.value);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Logindata(
                                    username: widget.username,
                                    dob: widget.dob,
                                    CollageName: _collagenameController
                                        .dropDownValue!.value,
                                    semester: _semesterController
                                        .dropDownValue!.value,
                                  )),
                        );
                      },
                      child: Text('Next')),
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
          ),
        );
      }),
    );
  }

  @override
  void dispose() {
    _semesterController.dispose();
    super.dispose();
  }
}
