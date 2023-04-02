import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  final _formKey = GlobalKey<FormState>();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final _textController4 = TextEditingController();
  final _textController5 = TextEditingController();

  Future<dynamic> getData() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        return documentSnapshot.data();
      }
    });
  }

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
                          : user!.displayName == ""
                            ? user!.email?.split('@')[0] as String
                            : user!.displayName as String,
                      style:
                      const TextStyle(fontSize: 40, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            FutureBuilder(
              future: getData(),
              builder: (context, snapshot) {
                if(snapshot.hasData) {
                  return Column(
                    children: [
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
                              child: Text(snapshot.data['full_name'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
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
                              child: Text(snapshot.data['email'], style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
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
                              child: const Text('Phone Number :', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                            ),
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 30),
                              child: Text(snapshot.data['phone_number'], style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
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
                              child: Text(snapshot.data['license_plate'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
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
                              child: Text(snapshot.data['vehicle_brand'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
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
                              child: Text(snapshot.data['add_info'], style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color(0xFFAC5757)),),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 60,
                        width: 120,
                        margin: EdgeInsets.only(top: 30),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: const Color(0xFFAC5757),
                            foregroundColor: Colors.white,
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: AlertDialog(
                                    backgroundColor: const Color(0xFFFBF2CF),
                                    title: const Text('Edit Personal Information',
                                        style: TextStyle(
                                            fontSize: 30,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFFAC5757)),
                                        textAlign: TextAlign.center),
                                    content: Form(
                                      key: _formKey,
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: const Text(
                                              'Full Name:',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFAC5757),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            key: _formKey,
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              controller: _textController1,
                                              maxLength: 15,
                                              decoration: const InputDecoration(
                                                labelText: 'Edit Your Name',
                                                hintText: 'Edit your name here',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return snapshot.data['full_name'];
                                                }
                                                return null;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data['full_name'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: const Text(
                                              'Phone Number',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFAC5757),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              controller: _textController2,
                                              maxLength: 10,
                                              decoration: const InputDecoration(
                                                labelText: 'Edit Phone Number',
                                                hintText: 'Edit phone number here',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return snapshot.data['phone_number'];
                                                }
                                                return value;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data['phone_number'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: const Text(
                                              'License Plate',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFAC5757),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              controller: _textController3,
                                              decoration: const InputDecoration(
                                                labelText: 'Edit License Plate',
                                                hintText: 'Edit license plate here',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return snapshot.data['license_plate'];
                                                }
                                                return value;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data['license_plate'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: const Text(
                                              'Vehicle Brand',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFAC5757),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              controller: _textController4,
                                              decoration: const InputDecoration(
                                                labelText: 'Edit Vehicle Brand',
                                                hintText: 'Edit vehicle brand here',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return snapshot.data['vehicle_brand'];
                                                }
                                                return value;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data['vehicle_brand'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 16),
                                            child: const Text(
                                              'Additional Information',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Color(0xFFAC5757),
                                                  fontWeight: FontWeight.w800),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: TextFormField(
                                              controller: _textController5,
                                              decoration: const InputDecoration(
                                                labelText: 'Edit Additional Information',
                                                hintText: 'Edit additional information here',
                                              ),
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return snapshot.data['add_info'];
                                                }
                                                return value;
                                              },
                                              onChanged: (value) {
                                                setState(() {
                                                  snapshot.data['add_info'] = value;
                                                });
                                              },
                                            ),
                                          ),
                                          Container(
                                            child: Row(
                                              children: [
                                                Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 14, top: 20, right: 10),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: const Color(0xFFAC5757),
                                                      foregroundColor: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        snapshot.data;
                                                      });
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'SAVE',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  margin:
                                                  const EdgeInsets.only(top: 20, left: 10),
                                                  child: TextButton(
                                                    style: TextButton.styleFrom(
                                                      backgroundColor: Colors.grey,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(context);
                                                    },
                                                    child: const Text(
                                                      'CANCEL',
                                                      style: TextStyle(
                                                          fontSize: 30,
                                                          fontWeight: FontWeight.bold),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }
                            );
                          },
                          child: const Text('EDIT', style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  );
                } else {
                  return Expanded(
                    child: Transform.translate(
                      offset: Offset(0, -50),
                      child: LoadingAnimationWidget.inkDrop(color: Colors.white, size: 40),
                    ),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
