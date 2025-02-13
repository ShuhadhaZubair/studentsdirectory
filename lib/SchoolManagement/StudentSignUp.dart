import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machinetest/SchoolManagement/Login.dart';
import 'package:machinetest/SchoolManagement/StudentHome.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Studentsignup extends StatefulWidget {
  const Studentsignup({super.key});

  @override
  State<Studentsignup> createState() => _StudentsignupState();
}

class _StudentsignupState extends State<Studentsignup> {
  String id = "";
  bool _isLoading = false;
  final formkey = GlobalKey<FormState>();
  var name = TextEditingController();
  var email = TextEditingController();
  var password = TextEditingController();
  var department = TextEditingController();
  var place = TextEditingController();
  Future<void> add_student_details() async{
    FirebaseFirestore.instance.collection("studentsdetails").add({
      "name" : name.text,
      "email" : email.text,
      "password" : password.text,
      "department" : department.text,
      "place" : place.text,
      "status" : 0
    });

    print("Hello");

    Navigator.push(context, MaterialPageRoute(builder: (context) => Studenthome(),));
  }
  // Future<void> _signup() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() {
  //       _isLoading = true;
  //     });
  //
  //     try {
  //       final userCredential = await FirebaseAuth.instance
  //           .createUserWithEmailAndPassword(
  //         email: email.text,
  //         password: password.text,
  //       );
  //
  //       final userId = userCredential.user!.uid; // Get the user's UID
  //
  //       await FirebaseFirestore.instance
  //           .collection("studentsdetails")
  //           .doc(userId) // Use the UID as the document ID
  //           .set({
  //         "name": name.text,
  //         "email": email.text,
  //         "password": password.text, // In a real app, hash the password!
  //         "department": department.text,
  //         "place": place.text,
  //         "status": 0,
  //       });
  //
  //       SharedPreferences prefs = await SharedPreferences.getInstance();
  //       await prefs.setString('studentid', userId); // Store the UID
  //
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content:
  //             Text('Signup successful. Please wait for admin approval.')),
  //       );
  //
  //       Navigator.pushReplacement( // Use pushReplacement
  //           context, MaterialPageRoute(builder: (context) => Studenthome()));
  //
  //     } on FirebaseAuthException catch (e) {
  //       String errorMessage = "An error occurred during signup.";
  //       if (e.code == 'weak-password') {
  //         errorMessage = 'The password provided is too weak.';
  //       } else if (e.code == 'email-already-in-use') {
  //         errorMessage = 'The account already exists for that email.';
  //       } // Add other error codes as needed
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(content: Text(errorMessage)),
  //       );
  //     } catch (e) {
  //       print("Error during signup: $e");
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(
  //             content: Text('An error occurred. Please try again later.')),
  //       );
  //     } finally {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://5.imimg.com/data5/RX/NO/MY-24297425/eacademics-school-28complete-school-management-software-with-mobile-app-29.png"))),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Student Signup',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 50),
                  TextFormField(
                    controller: name,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid ";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Username", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(controller: email,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid ";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Email", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(controller: password,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid ";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Password", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(controller: department,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid ";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Department", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 10),
                  TextFormField(controller: place,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Invalid ";
                      }
                    },
                    decoration: InputDecoration(
                        hintText: "Place", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      if (formkey.currentState!.validate()){
                        add_student_details();
                      }

                    },
                    child: Container(
                      height: 50,
                      width: 250,
                      decoration: BoxDecoration(
                          color: Colors.blue.shade900,
                          borderRadius: BorderRadius.circular(10)),
                      child: Center(
                          child: Text(
                        "SignUp",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminLogin()));
                    },
                    child: Text(
                      "Already have an account? LogIn",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
