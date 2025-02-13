import 'package:flutter/material.dart';
import 'package:machinetest/MAchineTest1/LogIn.dart';
import 'package:machinetest/SchoolManagement/Login.dart';


class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:  Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AdminLogin(),));
              },
              child: Container(
                height: 300,
                width: 300,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(
                            "https://5.imimg.com/data5/RX/NO/MY-24297425/eacademics-school-28complete-school-management-software-with-mobile-app-29.png"))),
              ),
            ),

            ],)

        ),

    );
  }
}
