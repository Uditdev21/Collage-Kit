import 'package:cloud_firestore/cloud_firestore.dart';

class CollageServices {
  final CollectionReference collageDB =
      FirebaseFirestore.instance.collection('Collages');

  Future<List<String>> getCollagesNames() async {
    try {
      QuerySnapshot querySnapshot = await collageDB.get();
      List<String> collegeNames = querySnapshot.docs.map((doc) {
        return doc['name'] as String;
      }).toList();
      print(collegeNames);
      return collegeNames;
    } catch (e) {
      print('Error getting college names: $e');
      return [];
    }
  }
}
