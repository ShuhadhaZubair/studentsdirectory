import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:machinetest/LogIn.dart';
import 'package:machinetest/provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";
  DocumentSnapshot? userprofile;
  var user;


  Future<void> getdata() async {
    SharedPreferences data = await SharedPreferences.getInstance();
    String? userId = data.getString("userid");

    if (userId != null) {
      DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection("details").doc(userId).get();

      setState(() {
        user = userId;
        userprofile = userDoc;
        print("$user data fetched");
      });
    }

  }


  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    print("hello");
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Login(),
        ));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
    Provider.of<StudentProvider>(context, listen: false).fetchStudents();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 5,
        child: Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(),
              ),
              title: Row(
                children: [ Text(
                  "Hi", // Use userName variable
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
                  Text(
                    userprofile?["name"] ??"", // Use userName variable
                    style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
              backgroundColor: Color.fromARGB(255, 18, 54, 80),
              actions: [
                IconButton(
                  icon: Icon(Icons.logout, color: Colors.white),
                  onPressed: () {
                    signOut();
                  },
                ),
              ],
            ),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(children: [
                  Text(
                    "Students Enrolled",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TabBar(
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.black,
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color.fromARGB(255, 18, 54, 80),
                    ),
                    isScrollable: true,
                    tabs: [
                      Tab(
                        child: Text(
                          'All',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Flutter',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Mern',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'UI/UX',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Digital Markaeting',
                          style: TextStyle(
                            // color: Colors.white,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        All(),
                        Flutter(),
                        Mern(),
                        Uiux(),
                        DigitalMarketing()
                      ],
                    ),
                  ),
                ]))));
  }
}

class All extends StatefulWidget {
  const All({super.key});

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: search,
              onChanged: (value) {
                setState(() {
                  searchquery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hintText: 'Search students...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none),
                suffixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 18, 54, 80)),
                fillColor: Colors.grey.shade300,
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedSort,
            items: [
              'Sort',
              'Ascending',
              'Descending',
            ]
                .map((sortOption) => DropdownMenuItem(
                    value: sortOption, child: Text(sortOption)))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSort = newValue!;
              });
            },
            underline: SizedBox(), // Removes default underline
          ),
        ],
      ),

      SizedBox(height: 20),

      // Student List
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("details").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError) return Text("Error  ${snapshot.error}");
            final student = snapshot.data!.docs.where((doc) {
              String students = doc["name"].toString().toLowerCase();
              return students.contains(searchquery);
            }).toList();
            if (selectedSort == 'Ascending') {
              student
                  .sort((a, b) => a["name"].toString().toLowerCase().compareTo(
                        b["name"].toString().toLowerCase(),
                      ));
            } else if (selectedSort == 'Descending') {
              student
                  .sort((a, b) => b["name"].toString().toLowerCase().compareTo(
                        a["name"].toString().toLowerCase(),
                      ));
            }

            if (student.isEmpty) {
              return Center(child: Text("No students found"));
            }

            return ListView.builder(
              itemCount: studentProvider.students.length, // Placeholder data
              itemBuilder: (context, index) {
                var doc = student[index];
                final _data = studentProvider.students[index].data()
                    as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 18, 54, 80),
                      child: Text(
                        (_data["name"] ?? "").isNotEmpty
                            ? _data["name"]![0].toUpperCase()
                            : "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      _data["name"] ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_data["field"] ?? ""),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]));
  }
}

class Flutter extends StatefulWidget {
  const Flutter({super.key});

  @override
  State<Flutter> createState() => _FlutterState();
}

class _FlutterState extends State<Flutter> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
        body: Column(children: [
      SizedBox(
        height: 20,
      ),
      Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: search,
              onChanged: (value) {
                setState(() {
                  searchquery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 16),
                hintText: 'Search students...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide.none),
                suffixIcon:
                    Icon(Icons.search, color: Color.fromARGB(255, 18, 54, 80)),
                fillColor: Colors.grey.shade300,
                filled: true,
              ),
            ),
          ),
          SizedBox(width: 10),
          DropdownButton<String>(
            value: selectedSort,
            items: [
              'Sort',
              'Ascending',
              'Descending',
            ]
                .map((sortOption) => DropdownMenuItem(
                    value: sortOption, child: Text(sortOption)))
                .toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedSort = newValue!;
              });
            },
            underline: SizedBox(), // Removes default underline
          ),
        ],
      ),

      SizedBox(height: 20),

      // Student List
      Expanded(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("details")
              .where("field", isEqualTo: 'Flutter FullStack')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());
            else if (snapshot.hasError) return Text("Error  ${snapshot.error}");
            final student = snapshot.data!.docs.where((doc) {
              String students = doc["name"].toString().toLowerCase();
              return students.contains(searchquery);
            }).toList();
            if (selectedSort == 'Ascending') {
              student
                  .sort((a, b) => a["name"].toString().toLowerCase().compareTo(
                        b["name"].toString().toLowerCase(),
                      ));
            } else if (selectedSort == 'Descending') {
              student
                  .sort((a, b) => b["name"].toString().toLowerCase().compareTo(
                        a["name"].toString().toLowerCase(),
                      ));
            }

            if (student.isEmpty) {
              return Center(child: Text("No students found"));
            }

            return ListView.builder(
              itemCount: student.length, // Placeholder data
              itemBuilder: (context, index) {
                var doc = student[index];
                final _data = doc.data() as Map<String, dynamic>;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Color.fromARGB(255, 18, 54, 80),
                      child: Text(
                        (_data["name"] ?? "").isNotEmpty
                            ? _data["name"]![0].toUpperCase()
                            : "",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Text(
                      _data["name"] ?? "",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(_data["field"] ?? ""),
                    trailing: Icon(Icons.arrow_forward_ios, size: 18),
                  ),
                );
              },
            );
          },
        ),
      ),
    ]));
  }
}

class Mern extends StatefulWidget {
  const Mern({super.key});

  @override
  State<Mern> createState() => _MernState();
}

class _MernState extends State<Mern> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: search,
                onChanged: (value) {
                  setState(() {
                    searchquery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'Search students...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  suffixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 18, 54, 80)),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                ),
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedSort,
              items: [
                'Sort',
                'Ascending',
                'Descending',
              ]
                  .map((sortOption) => DropdownMenuItem(
                      value: sortOption, child: Text(sortOption)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                });
              },
              underline: SizedBox(), // Removes default underline
            ),
          ],
        ),

        SizedBox(height: 20),

        // Student List
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("details")
                .where("field", isEqualTo: 'Mern FullStack')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("Error  ${snapshot.error}");
              final student = snapshot.data!.docs.where((doc) {
                String students = doc["name"].toString().toLowerCase();
                return students.contains(searchquery);
              }).toList();
              if (selectedSort == 'Ascending') {
                student.sort(
                    (a, b) => a["name"].toString().toLowerCase().compareTo(
                          b["name"].toString().toLowerCase(),
                        ));
              } else if (selectedSort == 'Descending') {
                student.sort(
                    (a, b) => b["name"].toString().toLowerCase().compareTo(
                          a["name"].toString().toLowerCase(),
                        ));
              }

              if (student.isEmpty) {
                return Center(child: Text("No students found"));
              }

              return ListView.builder(
                itemCount: student.length, // Placeholder data
                itemBuilder: (context, index) {
                  var doc = student[index];
                  final _data = doc.data() as Map<String, dynamic>;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 18, 54, 80),
                        child: Text(
                          (_data["name"] ?? "").isNotEmpty
                              ? _data["name"]![0].toUpperCase()
                              : "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _data["name"] ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_data["field"] ?? ""),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class Uiux extends StatefulWidget {
  const Uiux({super.key});

  @override
  State<Uiux> createState() => _UiuxState();
}

class _UiuxState extends State<Uiux> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: search,
                onChanged: (value) {
                  setState(() {
                    searchquery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'Search students...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  suffixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 18, 54, 80)),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                ),
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedSort,
              items: [
                'Sort',
                'Ascending',
                'Descending',
              ]
                  .map((sortOption) => DropdownMenuItem(
                      value: sortOption, child: Text(sortOption)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                });
              },
              underline: SizedBox(), // Removes default underline
            ),
          ],
        ),

        SizedBox(height: 20),

        // Student List
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("details")
                .where("field", isEqualTo: 'UI/UX Designing')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("Error  ${snapshot.error}");
              final student = snapshot.data!.docs.where((doc) {
                String students = doc["name"].toString().toLowerCase();
                return students.contains(searchquery);
              }).toList();
              if (selectedSort == 'Ascending') {
                student.sort(
                    (a, b) => a["name"].toString().toLowerCase().compareTo(
                          b["name"].toString().toLowerCase(),
                        ));
              } else if (selectedSort == 'Descending') {
                student.sort(
                    (a, b) => b["name"].toString().toLowerCase().compareTo(
                          a["name"].toString().toLowerCase(),
                        ));
              }

              if (student.isEmpty) {
                return Center(child: Text("No students found"));
              }

              return ListView.builder(
                itemCount: student.length, // Placeholder data
                itemBuilder: (context, index) {
                  var doc = student[index];
                  final _data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 18, 54, 80),
                        child: Text(
                          (_data["name"] ?? "").isNotEmpty
                              ? _data["name"]![0].toUpperCase()
                              : "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _data["name"] ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_data["field"] ?? ""),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}

class DigitalMarketing extends StatefulWidget {
  const DigitalMarketing({super.key});

  @override
  State<DigitalMarketing> createState() => _DigitalMarketingState();
}

class _DigitalMarketingState extends State<DigitalMarketing> {
  String selectedSort = 'Sort';
  String selectedCategory = 'All';
  TextEditingController search = TextEditingController();
  String searchquery = "";

  @override
  Widget build(BuildContext context) {
    final studentProvider = Provider.of<StudentProvider>(context);
    return Scaffold(
      body: Column(children: [
        SizedBox(
          height: 20,
        ),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: search,
                onChanged: (value) {
                  setState(() {
                    searchquery = value.toLowerCase();
                  });
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16),
                  hintText: 'Search students...',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide.none),
                  suffixIcon: Icon(Icons.search,
                      color: Color.fromARGB(255, 18, 54, 80)),
                  fillColor: Colors.grey.shade300,
                  filled: true,
                ),
              ),
            ),
            SizedBox(width: 10),
            DropdownButton<String>(
              value: selectedSort,
              items: [
                'Sort',
                'Ascending',
                'Descending',
              ]
                  .map((sortOption) => DropdownMenuItem(
                      value: sortOption, child: Text(sortOption)))
                  .toList(),
              onChanged: (String? newValue) {
                setState(() {
                  selectedSort = newValue!;
                });
              },
              underline: SizedBox(), // Removes default underline
            ),
          ],
        ),

        SizedBox(height: 20),

        // Student List
        Expanded(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("details")
                .where("field", isEqualTo: 'Digital Marketing')
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              else if (snapshot.hasError)
                return Text("Error  ${snapshot.error}");
              final student = snapshot.data!.docs.where((doc) {
                String students = doc["name"].toString().toLowerCase();
                return students.contains(searchquery);
              }).toList();
              if (selectedSort == 'Ascending') {
                student.sort(
                    (a, b) => a["name"].toString().toLowerCase().compareTo(
                          b["name"].toString().toLowerCase(),
                        ));
              } else if (selectedSort == 'Descending') {
                student.sort(
                    (a, b) => b["name"].toString().toLowerCase().compareTo(
                          a["name"].toString().toLowerCase(),
                        ));
              }

              if (student.isEmpty) {
                return Center(child: Text("No students found"));
              }

              return ListView.builder(
                itemCount: student.length, // Placeholder data
                itemBuilder: (context, index) {
                  var doc = student[index];
                  final _data = doc.data() as Map<String, dynamic>;

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color.fromARGB(255, 18, 54, 80),
                        child: Text(
                          (_data["name"] ?? "").isNotEmpty
                              ? _data["name"]![0].toUpperCase()
                              : "",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      title: Text(
                        _data["name"] ?? "",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_data["field"] ?? ""),
                      trailing: Icon(Icons.arrow_forward_ios, size: 18),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ]),
    );
  }
}
