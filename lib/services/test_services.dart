import 'package:cloud_firestore/cloud_firestore.dart';

class TestServices {
  final myStream = FirebaseFirestore.instance.collection('test');
  Stream<DocumentSnapshot> showtestdat() {
    final doc = myStream.doc('pjun5csutbHnOV50AxeH').snapshots();
    return doc;
  }

  Future<void> showdata() {
    final doc = myStream.doc('pjun5csutbHnOV50AxeH').get();
    print(doc);
    return doc;
  }
}
