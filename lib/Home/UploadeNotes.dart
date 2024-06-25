import 'dart:io';

import 'package:collagekit/Home/PageDrawer.dart';
import 'package:collagekit/services/collage_services.dart';
import 'package:collagekit/services/storage_services.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class Uploadenotes extends StatefulWidget {
  const Uploadenotes({super.key});

  @override
  State<Uploadenotes> createState() => _UploadenotesState();
}

class _UploadenotesState extends State<Uploadenotes> {
  final Notekey = GlobalKey<FormState>();
  TextEditingController _subjectController = TextEditingController();
  TextEditingController _testController = TextEditingController();
  late SingleValueDropDownController _semesterController;
  late SingleValueDropDownController _collagenameController;
  late List<DropDownValueModel> _semlist;
  late List<DropDownValueModel> _collagenamesmodel;
  late List<String> _collagenames;
  bool _dataReady = false;
  CollageServices services = CollageServices();
  bool isFilePicked = false;
  FilePickerResult? result;
  storageServices storeageservices = storageServices();
  bool _collagedataready = false;

  void initState() {
    super.initState();
    _semesterController = SingleValueDropDownController();
    _collagenameController = SingleValueDropDownController();
    _initializeSemList();
  }

  void _initializeSemList() {
    List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
    _initilizecollageList();
    _semlist = semesters.map((semester) {
      return DropDownValueModel(name: semester, value: semester);
    }).toList();

    setState(() {
      _dataReady = true;
    });
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

  Future<void> pickFile() async {
    try {
      result = await FilePicker.platform.pickFiles();
      if (result != null) {
        setState(() {
          isFilePicked = true; // Set the flag to true
        });
        print('File picked: ${result!.files.first.name}');
      } else {
        print('No file selected.');
      }
    } catch (e) {
      print('Error picking file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploade note"),
        centerTitle: true,
      ),
      drawer: Pagedrawer(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Form(
              key: Notekey,
              child: Column(
                children: [
                  const Text("Collage"),
                  DropDownTextField(
                    controller: _collagenameController,
                    enableSearch: true,
                    dropDownList: _collagedataready
                        ? _collagenamesmodel
                        : [], // Provide your list of collages here
                  ),
                  const Text('Semester'),
                  DropDownTextField(
                    enableSearch: true,
                    controller: _semesterController,
                    dropDownList: _dataReady ? _semlist : [],
                  ),
                  const Text("subject"),
                  TextFormField(
                    controller: _subjectController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter  subject name';
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: !isFilePicked ? true : false,
                        child: TextButton(
                          onPressed: isFilePicked ? null : pickFile,
                          // Disable the button if a file is already picked
                          child: Text('Pick a file to upload'),
                        ),
                      ),
                      if (isFilePicked)
                        Text('Picked file: ${result!.files.first.name}'),
                      Visibility(
                        visible: isFilePicked ? true : false,
                        child: TextButton(
                            onPressed: () {
                              pickFile();
                            },
                            child: Text("select another File")),
                      )
                    ],
                  ),
                  TextButton(
                      onPressed: () {
                        storeageservices.UploadeFile(
                            collage: _subjectController.text,
                            Semester: int.parse(_testController.text),
                            Subject: _subjectController.text,
                            File: result!);
                      },
                      child: Text("Uploade"))
                ],
              ));
        },
      ),
    );
  }
}
