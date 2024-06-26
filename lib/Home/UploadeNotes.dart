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
  late SingleValueDropDownController _semesterController;
  late SingleValueDropDownController _collagenameController;
  late List<DropDownValueModel> _semlist;
  late List<DropDownValueModel> _collagenamesmodel;
  late List<String> _collagenames;
  bool _dataReady = false;
  CollageServices services = CollageServices();
  bool isFilePicked = false;
  FilePickerResult? result;
  StorageServices storeageservices = StorageServices();
  bool _collagedataready = false;

  @override
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
    _collagenamesmodel = _collagenames.map((college) {
      return DropDownValueModel(name: college, value: college);
    }).toList();
    setState(() {
      _collagedataready = true;
    });
  }

  Future<void> pickFile() async {
    try {
      result = await FilePicker.platform.pickFiles(withData: true);
      if (result != null) {
        setState(() {
          isFilePicked = true;
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
        title: Text("Upload note"),
        centerTitle: true,
      ),
      drawer: Pagedrawer(),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return Form(
            key: Notekey,
            child: Column(
              children: [
                const Text("College"),
                DropDownTextField(
                  controller: _collagenameController,
                  enableSearch: true,
                  dropDownList: _collagedataready ? _collagenamesmodel : [],
                ),
                const Text('Semester'),
                DropDownTextField(
                  enableSearch: true,
                  controller: _semesterController,
                  dropDownList: _dataReady ? _semlist : [],
                ),
                const Text("Subject"),
                TextFormField(
                  controller: _subjectController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter subject name';
                    }
                    return null;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: !isFilePicked,
                      child: TextButton(
                        onPressed: isFilePicked ? null : pickFile,
                        child: Text('Pick a file to upload'),
                      ),
                    ),
                    if (isFilePicked)
                      Text('Picked file: ${result!.files.first.name}'),
                    Visibility(
                      visible: isFilePicked,
                      child: TextButton(
                        onPressed: pickFile,
                        child: Text("Select another file"),
                      ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () async {
                    if (Notekey.currentState!.validate()) {
                      if (_collagenameController.dropDownValue == null) {
                        print('College not selected');
                        return;
                      }

                      if (_semesterController.dropDownValue == null) {
                        print('Semester not selected');
                        return;
                      }

                      if (!isFilePicked || result == null) {
                        print('No file selected');
                        return;
                      }

                      try {
                        await storeageservices.uploadFile(
                          collage: _collagenameController.dropDownValue!.value,
                          semester: int.parse(
                              _semesterController.dropDownValue!.value),
                          subject: _subjectController.text,
                          file: result!,
                        );
                        print('File uploaded successfully');
                      } catch (e) {
                        print('Error uploading file: $e');
                      }
                    }
                  },
                  child: Text("Upload"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
