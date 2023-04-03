import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({Key? key}) : super(key: key);

  @override
  EmergencyContactScreenState createState() => EmergencyContactScreenState();
}

class EmergencyContactScreenState extends State<EmergencyContactScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  String? name;
  String? number;
  List<List<String>> _list = [];

  @override
  void dispose() {
    _nameController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _addContact() {
    _list.add([
      _nameController.text,
      _numberController.text,
    ]);
    _nameController.clear();
    _numberController.clear();
  }

  void _loadData() async {
    if (user!.isAnonymous) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> dataAsString = prefs.getStringList("data") ?? [];
      setState(() {
        _list = dataAsString.map((string) => string.split(",")).toList();
      });
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) async {
        if (documentSnapshot.exists) {
          _list = List.from(documentSnapshot.get('emergency_contacts')).map((e) => (e as String).split(",")).toList();
          if (_list.isEmpty) {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            List<String> dataAsString = prefs.getStringList("data") ?? [];
            _list = dataAsString.map((string) => string.split(",")).toList();
            if (_list.isNotEmpty) {
              _saveData();
            }
          }
          setState(() {
          });
          return documentSnapshot.data();
        }
      });
    }
  }

  void _saveData() async {
    if (user!.isAnonymous) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> dataAsString = _list.map((list) => list.join(",")).toList();
      prefs.setStringList("data", dataAsString);
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .update({
        "emergency_contacts" : _list.map((list) => list.join(",")).toList()
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadData();
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
                      margin: const EdgeInsets.only(top: 20, bottom: 10, left: 5),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Icon(
                          Icons.arrow_back,
                          size: 45,
                          color: Color(0xFFAC5757),
                        ),
                      )),
                  Container(
                    margin: const EdgeInsets.only(top: 20, bottom: 10),
                    child: const Text(
                      "Emergency Contacts",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFFAC5757)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    height: 120,
                    padding: const EdgeInsets.only(left: 12),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 9.0,
                          spreadRadius: 1.0,
                          offset: Offset(
                            5.0,
                            5.0,
                          ),
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          child: const Icon(
                            Icons.phone_outlined,
                            size: 45,
                          ),
                        ),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.only(top: 30, left: 28),
                                child: Text(
                                  _list[index][0],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.only(top: 5, left: 28, right: 65),
                                child: Text(
                                  _list[index][1],
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.left,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            // margin: const EdgeInsets.only(),
                            child: FloatingActionButton(
                              heroTag: "btn1",
                              onPressed: () {
                                setState(() {
                                  _list.removeAt(index);
                                  _saveData();
                                });
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(Icons.delete),

                            ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: AlertDialog(
                    backgroundColor: const Color(0xFFFBF2CF),
                    title: const Text('Enter Emergency Contact',
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
                              'Name:',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFAC5757),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _nameController,
                              maxLength: 15,
                              decoration: const InputDecoration(
                                labelText: 'Enter Your Name',
                                hintText: 'Enter your name here',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              onChanged: (value) {
                                setState(() {
                                  name = value;
                                });
                              },
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 16),
                            child: const Text(
                              'Contact number',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFAC5757),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _numberController,
                              maxLength: 10,
                              decoration: const InputDecoration(
                                labelText: 'Enter Contact Number',
                                hintText: 'Enter contact number here',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter contact number';
                                }
                                return value;
                              },
                              onChanged: (value) {
                                setState(() {
                                  number = value;
                                });
                              },
                            ),
                          ),
                          Row(
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
                                      _addContact();
                                    });
                                    _saveData();
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
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        backgroundColor: Colors.grey,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
