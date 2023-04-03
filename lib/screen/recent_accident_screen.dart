import 'package:flutter/material.dart';
import 'package:xpressready/components/list_element.dart';
import 'package:xpressready/model/accident_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:xpressready/screen/choose_location_screen.dart';
import 'package:xpressready/singleton/StoreManager.dart';

class RecentCrashScreen extends StatefulWidget {
  const RecentCrashScreen({Key? key}) : super(key: key);

  @override
  RecentCrashScreenState createState() => RecentCrashScreenState();
}

class RecentCrashScreenState extends State<RecentCrashScreen> {
  StoreManager storeManagerInstance = StoreManager();
  Future<List<Accident>?>? _accidentModel;
  String? selectedValue;
  Future<List<String>>? _expressWay;
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _accidentModel = storeManagerInstance.accidentList;
    _expressWay = storeManagerInstance.expressWayList;
  }

  // Future<List<Accident>?> _getData() async {
  //   return ApiService().getUsers();
  // }

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
            margin: const EdgeInsets.only(top: 40, bottom: 10),
            child: const Center(
              child: Text(
                "Recent Accidents on Expressway",
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFAC5757)),
              ),
            ),
          ),
          Flexible(
            child: Container(
                constraints: BoxConstraints(maxHeight: baseHeight * 0.5),
                margin: const EdgeInsets.only(top: 15),
                width: baseWidth * 0.95,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFAC5757).withOpacity(0.2),
                    border: Border.all(color: Colors.black12),
                    borderRadius:
                        const BorderRadius.all(Radius.circular(16.0))),
                child: FutureBuilder(
                  future: _accidentModel,
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: 5,
                          itemBuilder: (context, i) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: ListElement(data: snapshot.data![i]),
                            );
                          });
                    } else {
                      return Center(
                        child: LoadingAnimationWidget.inkDrop(
                          size: 40,
                          color: Colors.white,
                        ),
                      );
                    }
                  },
                )),
          ),
          Container(
            margin: const EdgeInsets.only(top: 30),
            child: const Center(
              child: Text(
                "Which expressway are you passing:",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFAC5757)),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 10),
            child: FutureBuilder(
              future: _expressWay,
              builder:
                  (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
                if (snapshot.hasData) {
                  print(snapshot.data);
                  return DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      isExpanded: true,
                      hint: const Text(
                        'Please choose one',
                        style:
                            TextStyle(fontSize: 20, color: Color(0xFFAC5757)),
                      ),
                      items: snapshot.data!
                          .map((item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFAC5757),
                                      fontWeight: FontWeight.w700),
                                ),
                              ))
                          .toList(),
                      value: selectedValue,
                      onChanged: (value) {
                        setState(() {
                          selectedValue = value as String;
                        });
                      },
                      buttonStyleData:
                          const ButtonStyleData(height: 35, width: 270),
                      dropdownStyleData: const DropdownStyleData(
                        maxHeight: 200,
                      ),
                      menuItemStyleData: const MenuItemStyleData(height: 35),
                      dropdownSearchData: DropdownSearchData(
                        searchController: textEditingController,
                        searchInnerWidgetHeight: 50,
                        searchInnerWidget: Container(
                          height: 50,
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                          child: TextFormField(
                            expands: true,
                            maxLines: null,
                            controller: textEditingController,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 8,
                              ),
                              hintText: 'Search for expressway',
                              hintStyle: const TextStyle(fontSize: 12),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        searchMatchFn: (item, searchValue) {
                          return (item.value.toString().contains(searchValue));
                        },
                      ),
                      onMenuStateChange: (isOpen) {
                        if (!isOpen) {
                          textEditingController.clear();
                        }
                      },
                    ),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
          ),
          Container(
            width: 300,
            margin: const EdgeInsets.only(top: 12),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: const Color(0xFFAC5757),
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                StoreManager storeManagerInstance = StoreManager();
                Navigator.push(context, MaterialPageRoute(builder: (context) => LocationScreen())).then(
                        (value) => print(storeManagerInstance.expressWayCross)
                );
              },
              child: const Text(
                'Check ExpressWay',
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
