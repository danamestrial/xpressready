import 'package:flutter/material.dart';
import 'component/listElement.dart';
import 'component/data.dart';
import 'model/accident_model.dart';
import 'service/api_service.dart';

class RecentCrashScreen extends StatefulWidget {
  const RecentCrashScreen({Key? key}) : super(key: key);

  @override
  RecentCrashScreenState createState() => RecentCrashScreenState();
}

class RecentCrashScreenState extends State<RecentCrashScreen> {

  late List<Accident>? _AccidentModel = [];

  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    _AccidentModel = (await ApiService().getUsers())!;
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
                  "Recent Accidents on Expressway",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                ),
              ),
            ),
            Flexible(
              child: Container(
                constraints: BoxConstraints(
                    maxHeight: baseHeight*0.5
                ),
                margin: const EdgeInsets.only(top: 15),
                width: baseWidth*0.95,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color(0xFFAC5757).withOpacity(0.2),
                    border: Border.all(color: Colors.black12),
                    borderRadius: const BorderRadius.all(Radius.circular(16.0))
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: 5,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: ListElement(data: _AccidentModel![i]),
                    );
                  }
                ),
              ),
            )
          ],
        )
      ),
    );
  }

}