import 'package:flutter/material.dart';
import 'package:xpressready/components/list_element.dart';
import 'package:xpressready/model/accident_model.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
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
  List<String> _expressWay = [];
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _accidentModel = storeManagerInstance.accidentList;
    super.initState();
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
                margin: const EdgeInsets.only(top: 40, bottom: 10),
                child: const Center(
                  child: Text(
                    "Recent Accidents on Expressway",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
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
                        borderRadius: const BorderRadius.all(Radius.circular(16.0))),
                    child: FutureBuilder(
                      future: _accidentModel,
                      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: _expressWay.length,
                      itemBuilder: (context, index) {
                        return Text(
                          _expressWay[index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 300,
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xFFAC5757),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen())).then((value) async {
                      setState(() {
                        _expressWay = storeManagerInstance.expressWayCross;
                      });
                    });
                  },
                  child: const Text(
                    'Check ExpressWay',
                    style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        )
      ),
    );
  }
}
