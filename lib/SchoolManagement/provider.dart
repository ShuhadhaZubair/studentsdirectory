import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentProvider extends ChangeNotifier {
  List<DocumentSnapshot> _students = [];
  bool _isLoading = true;
  String _error = '';

  List<DocumentSnapshot> get students => _students;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchStudents() async {
    _isLoading = true;
    notifyListeners(); // Notify listeners that data is loading

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection("studentsdetails")
          .get();
      _students = snapshot.docs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      print("Error fetching students: $e");
    }
  }

  Future<void> updateStatus(String docId, int newStatus) async {
    try {
      await FirebaseFirestore.instance
          .collection("studentsdetails")
          .doc(docId)
          .update({'status': newStatus});


      final index = _students.indexWhere((doc) => doc.id == docId);
      if (index != -1) {
        _students[index].reference.update({'status': newStatus});
        notifyListeners();
      }


    } catch (e) {
      print("Error updating status: $e");

      throw e;
    }
  }

  Future<void> deleteStudent(String docId) async {
    try {
      await FirebaseFirestore.instance
          .collection("studentsdetails")
          .doc(docId)
          .delete();
      _students.removeWhere((doc) => doc.id == docId);
      notifyListeners();
    } catch (e) {
      print("Error deleting student: $e");
      rethrow;
    }
  }
}