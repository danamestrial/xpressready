import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpressready/components/setting_element.dart';
import 'package:xpressready/services/gauth_service.dart';
import 'package:xpressready/screen/profile_screen.dart';

import '../components/notify_accident_button.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({Key? key}) : super(key: key);

  @override
  SettingScreenState createState() => SettingScreenState();
}

class SettingScreenState extends State<SettingScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  void signUserIn() {
    if (user!.isAnonymous) {
      user!.delete();
    }
  }

  Future<void> _launchPhone(String phone_number) async {
    Uri url = Uri.parse("tel:$phone_number");
    if (await canLaunchUrl(url)) {
      launchUrl(url);
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
                                user!.displayName=="" || user!.displayName==null?
                                  user!.email?.split('@')[0] as String : user!.displayName as String,
                              style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),

              MySettingElement(
                header: "Profile",
                subHeader: "user details, vehicle details",
                icon: const Icon(Icons.account_box_rounded, size: 70, color: Color(0xFFC55CF1),),
                onTap: () {
                  if (user!.isAnonymous) {
                    signUserIn();
                  }
                  else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ProfileScreen()
                      ),
                    );
                  }
                },
              ),

              MySettingElement(
                header: "Notify Accident",
                icon: const Icon(Icons.notifications, size: 70, color: Color(0xFFFF00C4),),
                onTap: (){
                  showDialog(
                    context: context,
                    builder: (context){
                      return AlertDialog(
                        backgroundColor: const Color(0xFFFBF2CF),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10.0))),
                        title: const Text('Call Emergency Hotline?',
                            style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFAC5757)),
                            textAlign: TextAlign.center),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            NotifyAccidentButton(text: 'Emergency Hotline', onTap: (){
                              _launchPhone("191");
                            },),
                            NotifyAccidentButton(text: 'Ambulance', onTap: (){
                              _launchPhone("+66-1669");
                            },),
                          ],
                        ),
                      );
                    });
                },
              ),

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