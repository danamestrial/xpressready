import 'dart:convert';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HitAndNotRunScreen extends StatefulWidget {
  const HitAndNotRunScreen({Key? key}) : super(key: key);

  @override
  HitAndNotRunScreenState createState() => HitAndNotRunScreenState();
}

class HitAndNotRunScreenState extends State<HitAndNotRunScreen> {
  final _formKey = GlobalKey<FormState>();
  final _textController1 = TextEditingController();
  final _textController2 = TextEditingController();
  final _textController3 = TextEditingController();
  final List<String> items = ['Hit Someone', 'Being Hit'];
  String? hit;
  String? name;
  String? plate;
  String? number;
  late final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  List<List<String>> _list = [];

  @override
  void dispose() {
    _textController1.dispose();
    _textController2.dispose();
    _textController3.dispose();
    super.dispose();
  }

  void _addContact() {
    _list.add([
      _textController1.text,
      hit as String,
      _textController2.text,
      _textController3.text
    ]);
    _textController1.clear();
    _textController2.clear();
    _textController3.clear();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataAsString = prefs.getStringList("data") ?? [];
    setState(() {
      _list = dataAsString.map((string) => string.split(",")).toList();
    });
  }

  void _saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> dataAsString = _list.map((list) => list.join(",")).toList();
    prefs.setStringList("data", dataAsString);
  }

  @override
  void initState() {
    super.initState();
    _loadData();
    _saveData();
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
                      margin: const EdgeInsets.only(top: 20, bottom: 10),
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
                      "Hit and Not Run Contacts",
                      style: TextStyle(
                          fontSize: 25,
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
                    height: 165,
                    padding: const EdgeInsets.only(top: 11, left: 12),
                    margin: const EdgeInsets.only(bottom: 16),
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
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                _list[index][1],
                                style: const TextStyle(
                                    fontSize: 22,
                                    color: Color(0xFFAC5757),
                                    fontWeight: FontWeight.w900),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Name: ${_list[index][0]}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFAC5757),
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Car Plate: ${_list[index][2]}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFAC5757),
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10),
                              child: Text(
                                "Contact Number: ${_list[index][3]}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color(0xFFAC5757),
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        Container(
                            margin: const EdgeInsets.only(left: 23),
                            child: FloatingActionButton(
                              onPressed: () {
                                setState(() {
                                  _list.removeAt(index);
                                  _saveData();
                                });
                              },
                              backgroundColor: Colors.red,
                              child: const Icon(Icons.delete),
                            )),
                      ],
                    ),
                  );
                },
              ),
            ),
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
                    title: const Text('Enter Contact Details',
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
                              'Are you being hit or did you hit someone ?',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: Color(0xFFAC5757),
                                  fontWeight: FontWeight.w800),
                            ),
                          ),
                          Container(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2(
                                hint: const Text(
                                  'Select Item',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xFFAC5757),
                                      fontWeight: FontWeight.w700),
                                ),
                                items: items
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(
                                          item,
                                          style: const TextStyle(
                                              fontSize: 15,
                                              color: Color(0xFFAC5757),
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    )
                                    .toList(),
                                value: hit,
                                onChanged: (value) {
                                  setState(() {
                                    hit = value as String;
                                  });
                                },
                                buttonStyleData: const ButtonStyleData(
                                  height: 40,
                                  width: 140,
                                ),
                                menuItemStyleData:
                                    const MenuItemStyleData(height: 40),
                              ),
                            ),
                          ),
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
                            key: _formKey,
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _textController1,
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
                            child: const Text('Car Plate:',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFFAC5757),
                                    fontWeight: FontWeight.w800)),
                          ),
                          Container(
                            padding: const EdgeInsets.only(top: 8),
                            child: TextFormField(
                              controller: _textController2,
                              decoration: const InputDecoration(
                                labelText: 'Enter Your Car Plate',
                                hintText: 'Enter your car plate here',
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter your car plate';
                                }
                                return value;
                              },
                              onChanged: (value) {
                                setState(() {
                                  plate = value;
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
                              controller: _textController3,
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
