import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final notesCollection = FirebaseFirestore.instance.collection('Notes');

  Future<void> uploadFile({
    required String collage,
    required int semester,
    required String subject,
    required FilePickerResult file,
  }) async {
    try {
      final String filename = '${collage}|${semester}|${subject}';
      print('Uploading file with filename: $filename');
      String fName = file.files.first.name;
      Uint8List? fileBytes = file.files.first.bytes;

      if (fileBytes == null) {
        print('File bytes are null');
        return;
      }

      final storageLocation = FirebaseStorage.instance.ref('Notes/$filename');
      await storageLocation.putData(fileBytes);
      final downloadUri = await storageLocation.getDownloadURL();
      print(downloadUri);

      await notesCollection.doc().set({
        'Collage': collage,
        'Semester': semester,
        'Subject': subject,
        'FileName': filename,
        'FileURL': downloadUri,
        'Approval': false,
      });

      print('File uploaded successfully');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}
