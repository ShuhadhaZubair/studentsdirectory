import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class StudentProvider with ChangeNotifier {
  List<DocumentSnapshot> _students = [];

  List<DocumentSnapshot> get students => _students;

  Future<void> fetchStudents() async {
    try {
      final QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('details').get();
      _students = querySnapshot.docs;
      notifyListeners();
    } catch (e) {
      print("Error fetching students: $e");
    }
  }
}