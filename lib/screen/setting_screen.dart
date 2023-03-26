import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:xpressready/components/setting_element.dart';
import 'package:xpressready/services/gauth_service.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  void signUserIn() {
    if (user!.isAnonymous) {
      GAuthService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {

    double baseWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Settings",
                      style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                    ),

                    SizedBox(width: 10,),

                    Icon(
                      Icons.settings,
                      size: 35,
                      color: Color(0xFFAC5757),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 15),
                width: baseWidth,
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                    color: const Color(0xFFAC5757).withOpacity(0.1),
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(30.0))
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        user!.isAnonymous || user!.photoURL==null?
                        const Icon(
                          Icons.account_circle,
                          size: 80,
                        ):Image.network(
                          user!.photoURL as String,
                          height: 80,
                        ),

                        const SizedBox(width: 10,),

                        Column(
                          children: [
                            Text(
                              user!.isAnonymous?"Guest" :
                                user!.displayName==null?
                                  user!.email as String : user!.displayName as String,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              const MySettingElement(
                header: "Profile",
                subHeader: "user details, vehicle details",
                icon: Icon(Icons.account_box_rounded, size: 70, color: Color(0xFFC55CF1),),),

              const MySettingElement(
                header: "Notify Accident",
                icon: Icon(Icons.notifications, size: 70, color: Color(0xFFFF00C4),),),

              const Spacer(),

              Container(
                child: user!.isAnonymous?
                Center(
                  child: TextButton(
                    onPressed: () { signUserIn(); },
                    style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                        backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(40.0),
                            )
                        )
                    ),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                      child: const Text(
                        "Sign In",
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  ),
                ):
                Center(
                  child: TextButton(
                      onPressed: () { GAuthService.signOut(); },
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40.0),
                              )
                          )
                      ),
                      child: Container(
                        padding: const EdgeInsets.fromLTRB(60, 15, 60, 15),
                        child: const Text(
                          "Log Out",
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                  ),
                ),
              ),

              const SizedBox(height: 20,),
            ],
        )
      ),
    );
  }
}