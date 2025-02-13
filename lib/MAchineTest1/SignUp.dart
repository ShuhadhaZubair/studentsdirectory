

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'Home.dart';
import 'LogIn.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final formkey= GlobalKey<FormState>();
  String _selectedItem = 'Flutter FullStack';
var name = TextEditingController();
  var place = TextEditingController();
  var password = TextEditingController();
  var field = TextEditingController();
  var email = TextEditingController();
  final List<String> _options = [
    'Flutter FullStack',
    'Mern FullStack',
    'UI/UX Designing',
    'Digital Marketing',
  ];

  Future<void> add_details() async{
    FirebaseFirestore.instance.collection("details").add({
      "name" : name.text,
      "place" : place.text,
      "password" : password.text,
      "field" : _selectedItem,
      "email" : email.text
    });
    print("Hello");
    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
  }




  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await _googleSignIn.signIn();
      if (googleSignInAccount == null) return;

      final GoogleSignInAuthentication googleAuth =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
      await _auth.signInWithCredential(credential);

      if (userCredential.user != null) {
        await _saveUserDataToFirestore(userCredential.user!);
        Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
      }
    } catch (error) {
      print("Google Sign-In Error: $error");
    }
  }

  Future<void> _saveUserDataToFirestore(User user) async {
    final DocumentSnapshot userDoc =
    await _firestore.collection("CrudUser").doc(user.uid).get();

    if (!userDoc.exists) {
      await _firestore.collection("CrudUser").doc(user.uid).set({
        'name': user.displayName,
        'email': user.email,
        'place': "",
        // Add additional fields like "Trade" and "OfficeLocation" if required
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(key: formkey,
        child: Stack(
          children: [
            // Background Image (Unblurred)
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    "https://creativesilhouettes.ca/wp-content/uploads/2021/03/mountain-landscape-pattern.jpg",
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),

            // Centered Blurred Container
            Center(
              child: Container(
                width: 350,
                height: 700,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Frosted glass effect
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Signup Text
                            Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Name Field
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Name',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.person, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Invalid ";
                                }
                              },
                              controller: name,
                            ),
                            SizedBox(height: 20),
                            // Place Field
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Place',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.location_on, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Invalid";
                                }
                              },
                              controller: place,
                            ),
                            SizedBox(height: 20),
                        
                            DropdownButtonFormField<String>(
                              value: _selectedItem,
                              items: _options.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,

                                  child: Text(value,style: TextStyle(color: Colors.white),),

                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedItem = newValue!;
                                });
                              },
                              decoration: InputDecoration(
                                // labelText: 'Field of Expertise',
                                // labelStyle: TextStyle(color: Colors.white70) ,
                                prefixIcon: Icon(Icons.work_outline, color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                              ),
                              dropdownColor: Color.fromARGB(255, 18, 54, 80) ,
                              // validator: (value){
                              //   if(value!.isEmpty){
                              //     return "Invalid USername";
                              //   }
                              // },
                            ),
                            SizedBox(height: 20),
                            // Email Field
                            TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.email, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Invalid";
                                }
                              },
                              controller: email,
                            ),
                            SizedBox(height: 20),
                            // Password Field
                            TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Icon(Icons.lock, color: Colors.white),
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.2),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Invalid";
                                } else if (value.length < 6) {
                                  return "Password must be at least 6 characters";
                                }
                                return null; // Validation passed
                              },
                              controller: password,
                            ),
                            SizedBox(height: 20),
                            // Sign Up Button
                            ElevatedButton(
                              onPressed: () {
                                if (formkey.currentState!.validate()){
                                  add_details();
                                }
                        
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 18, 54, 80),
                                padding: EdgeInsets.symmetric(horizontal: 80, vertical: 15),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                'Sign Up',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            Text("Or", style: TextStyle(color: Colors.white)),
                            SizedBox(height: 20),
                            InkWell(onTap: () {
                              signInWithGoogle();
                            },
                              child: Container(
                                height: 50,
                                width: 200,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  "https://static.vecteezy.com/system/resources/thumbnails/046/861/647/small/google-logo-transparent-background-free-png.png"))),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Text("SignUp with google",style: TextStyle(fontSize: 16,
                                      fontWeight: FontWeight.w500,),)
                                  ],
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => Login(),));// Go back to login page
                              },
                              child: Text(
                                "Already have an account? Login",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}







