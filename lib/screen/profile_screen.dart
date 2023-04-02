import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/gauth_service.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:iconify_flutter/icons/fa6_regular.dart';
import 'package:iconify_flutter/icons/zondicons.dart';
import 'package:iconify_flutter/icons/map.dart';
import 'package:iconify_flutter/icons/material_symbols.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ProfileScreenState createState() => ProfileScreenState();
}

class ProfileScreenState extends State<ProfileScreen> {
  final User? user = FirebaseAuth.instance.currentUser;

  void signUserIn() {
    if (user!.isAnonymous) {
      GAuthService.signOut();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  Container(
                    margin:
                    const EdgeInsets.only(top: 20, bottom: 10, left: 5),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back,
                        size: 45,
                        color: Color(0xFFAC5757),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10),
                    child: const Icon(
                      Icons.person,
                      size: 90,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 10, left: 8),
                    child: Text(
                      user!.isAnonymous
                          ? "Guest"
                          : user!.displayName == null
                          ? user!.email?.split('@')[0] as String
                          : user!.displayName as String,
                      style:
                      const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Iconify(Zondicons.user_solid_circle, size: 35,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text('Full Name :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text('Rasika Aramvejanan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Iconify(Map.post_office, size: 40,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text('Email :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: Text(user!.email as String, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20, top: 30),
                    child: const Icon(Icons.phone_rounded, size: 40,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text('Phone number :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 10, top: 30),
                    child: const Text('0856123456', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 38, left: 40, ),
                    child: const Iconify(MaterialSymbols.directions_car_rounded, size: 50,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 42, left: 10),
                    child: const Text('Vehicle Details', style: TextStyle(fontSize: 35, fontWeight: FontWeight.w700),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 20),
                    child: const Iconify(Fa6Regular.address_card, size: 35,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: const Text('License Plate :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: const Text('AB1234', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 15),
                    child: const Iconify(MaterialSymbols.car_crash, size: 40,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: const Text('Vehicle Brand :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: const Text('Toyota Ativ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 15),
                    child: const Iconify(MaterialSymbols.info, size: 40,),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(left: 7),
                          child: const Text('Additional', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        ),
                        Container(
                          child: const Text('Information', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 5),
                    child: const Text(':', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30, left: 10),
                    child: const Text('Toyota Ativ', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                  ),
                ],
              ),
            ),
            Container(),
          ],
        ),
      ),
    );
  }
}
