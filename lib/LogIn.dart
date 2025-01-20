import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:machinetest/SignUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final formkey = GlobalKey<FormState>();
  String id = "";
  var email = TextEditingController();
  var password = TextEditingController();

  Future<void> login() async {
    final user = await FirebaseFirestore.instance
        .collection("details")
        .where("email", isEqualTo: email.text)
        .where("password", isEqualTo: password.text)
        .get();

    if (user.docs.isNotEmpty){
      id=user.docs[0].id;
      SharedPreferences data = await SharedPreferences.getInstance();
      data.setString("userid", id);
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home(),));
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username and password Error')),
      );
    }
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
      body: Form(
        key: formkey,
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
                height: 500,
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white
                            .withOpacity(0.2), // Frosted glass effect
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1.5,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Login Text
                          Text(
                            'Login',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 20),
                          // Username Field
                          TextFormField(controller: email,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Invalid USername";
                              }
                            },
                            decoration: InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(color: Colors.white70),
                              prefixIcon:
                                  Icon(Icons.person, color: Colors.white),
                              filled: true,
                              fillColor: Colors.white.withOpacity(0.2),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: 20),
                          // Password Field
                          TextFormField(controller: password,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Invalid";
                              }
                            },
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
                          ),
                          SizedBox(height: 20),
                          // Login Button
                          ElevatedButton(
                            onPressed: () {
                              if (formkey.currentState!.validate()) {
                                login();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 18, 54, 80),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 80, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              'Login',
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
                                    width: 10,
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
                                    width: 10,
                                  ),
                                  Text(
                                    "LogIn with google",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                          // Signup Text
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Signup()));
                            },
                            child: Text(
                              " Don't have an account? Register",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
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
