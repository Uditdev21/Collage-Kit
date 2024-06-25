import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class storageServices {
  final Notes = FirebaseFirestore.instance.collection('Notes');
  final StorageLocation = FirebaseStorage.instance.ref('Notes');

  Future<void> UploadeFile(
      {required String collage,
      required int Semester,
      required String Subject,
      required FilePickerResult File}) async {
    final String Filename = '${collage}|${Semester}|${Subject}';
    print(Filename);
  }
}
