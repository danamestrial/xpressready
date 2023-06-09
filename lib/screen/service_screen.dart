import 'package:flutter/material.dart';
import 'package:xpressready/components/service_button.dart';
import 'package:xpressready/screen/emergency_contact_screen.dart';
import 'package:xpressready/screen/hit_and_not_run_screen.dart';
import 'package:xpressready/screen/nearest_services_screen.dart';

class EmergencyServiceScreen extends StatefulWidget {
  const EmergencyServiceScreen({Key? key}) : super(key: key);

  @override
  EmergencyServiceScreenState createState() => EmergencyServiceScreenState();
}

class EmergencyServiceScreenState extends State<EmergencyServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF2CF),
      body: SafeArea(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 40, bottom: 10),
                child: const Center(
                  child: Text(
                    "Services",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w800, color: Color(0xFFAC5757)),
                  ),
                ),
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 1,
                  childAspectRatio: (1 / .5),
                  children: [
                    ServiceButton(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HitAndNotRunScreen()
                            ),
                          );
                        }, text: 'Hit and NOT run service',
                    ),
                    ServiceButton(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmergencyContactScreen()
                            ),
                          );
                        }, text: 'Emergency Contact Guardians',
                    ),
                    ServiceButton(
                      onTap: (){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const NearestServiceScreen()
                          ),
                        );
                      }, text: 'Other Services',
                    ),
                  ],
                ),
              )
            ],
          )
      ),
    );
  }
}