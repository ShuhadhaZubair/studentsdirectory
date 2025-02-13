import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  var students = [].obs;
  var searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchStudents();
  }

  void fetchStudents() {
    FirebaseFirestore.instance.collection("studentsdetails").snapshots().listen((snapshot) {
      students.value = snapshot.docs;
    });
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query.toLowerCase();
  }

  void updateStudentStatus(String id, int status) {
    FirebaseFirestore.instance
        .collection("studentsdetails")
        .doc(id)
        .update({'status': status});
  }

  void deleteStudent(String id) {
    FirebaseFirestore.instance
        .collection("studentsdetails")
        .doc(id)
        .delete();
  }
}
