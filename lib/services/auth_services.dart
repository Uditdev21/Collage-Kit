import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authServices {
  final authSrvices = FirebaseAuth.instance;
  User? get CurrentUser => authSrvices.currentUser;
  final UsersDB = FirebaseFirestore.instance.collection('Users');

  Future<void> registerUser(
      {required String Email,
      required String Password,
      required String displayName,
      required DateTime DOB,
      required String Collage,
      required int Semester}) async {
    await authSrvices.createUserWithEmailAndPassword(
        email: Email, password: Password);

    await CurrentUser!.updateProfile(displayName: displayName);
    await CurrentUser!.sendEmailVerification();
    await StoreNewUser(
        Email: Email, DOB: DOB, Collage: Collage, Semester: Semester);
  }

  Future<void> StoreNewUser(
      {required String Email,
      required DateTime DOB,
      required String Collage,
      required int Semester}) async {
    DocumentReference UserDoc = UsersDB.doc(CurrentUser?.uid);
    int Year;
    if (Semester == 1 || Semester == 2) {
      Year = 1;
    } else if (Semester == 3 || Semester == 4) {
      Year = 2;
    } else if (Semester == 5 || Semester == 6) {
      Year = 3;
    } else {
      Year = 4;
    }
    await UserDoc.set({
      'Email': Email,
      'Date of Birth': DOB,
      'Collage': Collage,
      'semester': Semester,
      'Year': Year
    });
  }

  Future<void> LoginUser(
      {required String Email, required String Password}) async {
    await authSrvices.signInWithEmailAndPassword(
        email: Email, password: Password);
  }

  Future<void> singout() async {
    await authSrvices.signOut();
  }

  Future<void> resendVerificationMail() async {
    await CurrentUser!.sendEmailVerification();
  }
}
