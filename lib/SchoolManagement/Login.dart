import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:machinetest/SchoolManagement/StudentHome.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AdminDashboard.dart';
import 'StudentSignUp.dart';

class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _AdminLoginState();
}

class _AdminLoginState extends State<AdminLogin> {
  final formkey = GlobalKey<FormState>();
  String id = "";
  var email =TextEditingController();
  var password = TextEditingController();

  Future<void> login_details() async{
    final user = await FirebaseFirestore.instance
        .collection("studentsdetails")
        .where("email", isEqualTo: email.text)
        .where("password", isEqualTo: password.text)
        .get();
    if(email.text=="admin@gmail.com" && password.text == "123"){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Admindashboard(),));
    }
   else if (user.docs.isNotEmpty){
      id=user.docs[0].id;
      SharedPreferences data = await SharedPreferences.getInstance();
      data.setString("studentid", id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Studenthome(),));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password Error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: formkey,
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
                  'Login',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 50),
                TextFormField(controller: email,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Invalid ";
                    }
                  },
                ),
                SizedBox(height: 10),
                TextFormField(controller: password,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Invalid ";
                    }
                  },
                ),

                SizedBox(height: 30),
                InkWell(onTap: () {
                  if (formkey.currentState!.validate()){
                    login_details();

                  }
                },
                  child: Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                        color: Colors.blue.shade900,
                        borderRadius: BorderRadius.circular(10)),
                    child: Center(child: Text("Login",style: TextStyle(color: Colors.white,fontSize: 18),)),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Studentsignup()));
                  },
                  child: Text(
                    "Already have an account? SignUp",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
