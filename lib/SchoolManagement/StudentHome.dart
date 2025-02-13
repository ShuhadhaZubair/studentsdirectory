import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machinetest/SchoolManagement/Login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Studenthome extends StatefulWidget {
  const Studenthome({super.key});

  @override
  State<Studenthome> createState() => _StudenthomeState();
}

class _StudenthomeState extends State<Studenthome> {
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("hello");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AdminLogin(),
        ));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: () {
              signOut();
            }, icon: Icon(Icons.logout)),
          )],
          title: Text(
            'List of Enrollees',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StudentProfile(),
                      ));
                },
                child: CircleAvatar(
                  foregroundImage: NetworkImage(
                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUfE2gIZcFh8nZRxTX7EpdalVV5ZMiKMvLBQ&s"),
                )),
          ),
          centerTitle: true,
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("studentsdetails")
                .where("status", isEqualTo: 1)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("Error  ${snapshot.error}");
              final student = snapshot.data?.docs ?? [];
              return Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Expanded(
                      child: ListView.builder(
                        itemCount: student.length,
                        itemBuilder: (context, index) {
                          var doc = student[index];
                          final _data = doc.data() as Map<String, dynamic>;
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: ListTile(
                                title: Text(_data['name']!),
                                subtitle: Text(_data["department"]!),
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSz7CYwTE8WN3LQ4bAnBs2TJETLvIWK3bMqOQ&s"),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }));
  }
}

class StudentProfile extends StatefulWidget {
  const StudentProfile({super.key});

  @override
  State<StudentProfile> createState() => _StudentProfileState();
}

class _StudentProfileState extends State<StudentProfile> {
  var user;
  DocumentSnapshot? userp;
  Future<void> getstudentdata() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    setState(() {
      user = data.getString("studentid");
      print("$user data fetched");
    });
  }

  Future<void> getbyid() async {
    userp = await FirebaseFirestore.instance
        .collection("studentsdetails")
        .doc(user)
        .get();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getstudentdata();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditStudentProfile(),
                      ));
                },
                icon: Icon(Icons.edit_calendar_sharp))
          ],
          title: Text('Profile'),
          centerTitle: true,
        ),
        body: FutureBuilder(
            future: getbyid(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("Error ${snapshot.error}");
              return Center(
                child: Column(
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(
                          "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUfE2gIZcFh8nZRxTX7EpdalVV5ZMiKMvLBQ&s"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(userp!["name"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Email",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(userp!["email"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Place",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(userp!["place"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(
                          "Department",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 30,
                        ),
                        Text(userp!["department"],
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              );
            }));
  }
}

class EditStudentProfile extends StatefulWidget {
  const EditStudentProfile({super.key});

  @override
  State<EditStudentProfile> createState() => _EditStudentProfileState();
}

class _EditStudentProfileState extends State<EditStudentProfile> {
  var edit_name = TextEditingController();
  var edit_email = TextEditingController();
  var edit_department = TextEditingController();
  var edit_place = TextEditingController();

  var student;
  bool isLoading = true;

  Future<void> getdata() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    student = data.getString("studentid");
    print("$student data fetched");

    if (student != null) {
      var snapshot = await FirebaseFirestore.instance
          .collection("studentsdetails")
          .doc(student)
          .get();

      if (snapshot.exists) {
        var studentData = snapshot.data() as Map<String, dynamic>;
        setState(() {
          edit_name.text = studentData["name"] ?? "";
          edit_email.text = studentData["email"] ?? "";
          edit_department.text = studentData["department"] ?? "";
          edit_place.text = studentData["place"] ?? "";
          isLoading = false;
        });
      }
    }
  }
  @override
  void initState() {
    super.initState();
    getdata();
  }

  Future<void> update() async{
    FirebaseFirestore.instance.collection("studentsdetails").doc(student).update({
      "name" : edit_name.text,
      "email" : edit_email.text,
      "department" : edit_department.text,
      "place" : edit_place.text,

    });
   Navigator.push(context, MaterialPageRoute(builder: (context) => Studenthome(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile')),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(controller: edit_name,
              decoration: InputDecoration(
                  labelText: 'Name', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(controller: edit_email,
              decoration: InputDecoration(
                  labelText: 'Email', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(controller: edit_department,
              decoration: InputDecoration(
                  labelText: 'Department', border: OutlineInputBorder()),
            ),
            SizedBox(height: 10),
            TextField(controller: edit_place,
              decoration: InputDecoration(
                  labelText: 'Place', border: OutlineInputBorder()),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                update();
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
