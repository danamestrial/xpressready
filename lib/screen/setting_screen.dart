import 'package:flutter/material.dart';
import 'login_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {

  void signUserIn() {
    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  @override
  Widget build(BuildContext context) {

    double baseWidth = MediaQuery.of(context).size.width;
    double baseHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Center(
                  child: Text(
                    "Settings",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 15),
                  width: baseWidth,
                  padding: const EdgeInsets.fromLTRB(10,15,10,0),
                  decoration: BoxDecoration(
                      color: const Color(0xFFAC5757).withOpacity(0.1),
                      border: Border.all(color: Colors.black12),
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                              Icons.account_circle,
                            size: 80,
                          ),
                          Column(
                            children: const [
                              Text(
                                "Guest",
                                style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          width: baseWidth,
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.black12),
                              borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0))
                          ),
                          child: Center(
                            child: TextButton(
                              child: Text(
                                  "Sign In",
                                style: TextStyle(fontSize: 20),
                              ),
                              onPressed: () { signUserIn(); },
                              style: ButtonStyle(
                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                                backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  )
                                )
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }
}