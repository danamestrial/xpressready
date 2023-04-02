import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:xpressready/components/nearest_service_list.dart';
import 'package:xpressready/components/service_button.dart';
import 'package:xpressready/services/map_service.dart';

class NearestServiceScreen extends StatefulWidget {
  const NearestServiceScreen({Key? key}) : super(key: key);

  @override
  NearestServiceScreenState createState() => NearestServiceScreenState();
}

class NearestServiceScreenState extends State<NearestServiceScreen> {
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
                    "Nearest Services",
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
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Getting Nearest Hospital', style: TextStyle(fontSize: 22, color: Color(0xFFAC5757)),),
                              content: FutureBuilder(
                                future: GoogleMapService.getNearByPlaceByType('hospital'),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      height: MediaQuery.of(context).size.height*0.5,
                                      child: NearestServiceList(places: snapshot.data!,),
                                    );
                                  } else {
                                    return LoadingAnimationWidget.inkDrop(color: Colors.black, size: 40);
                                  }
                                },
                              )
                            );
                          },
                        );
                      }, text: 'Hospital',
                    ),
                    ServiceButton(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Getting Nearest Gas Station', style: TextStyle(fontSize: 22, color: Color(0xFFAC5757)),),
                                content: FutureBuilder(
                                  future: GoogleMapService.getNearByPlaceByType('gas_station'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height*0.5,
                                        child: NearestServiceList(places: snapshot.data!,),
                                      );
                                    } else {
                                      return LoadingAnimationWidget.inkDrop(color: Colors.black, size: 40);
                                    }
                                  },
                                )
                            );
                          },
                        );
                      }, text: 'Gas Station',
                    ),
                    ServiceButton(
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title: const Text('Getting Nearest Police Station', style: TextStyle(fontSize: 22, color: Color(0xFFAC5757)),),
                                content: FutureBuilder(
                                  future: GoogleMapService.getNearByPlaceByType('police'),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Container(
                                        height: MediaQuery.of(context).size.height*0.5,
                                        child: NearestServiceList(places: snapshot.data!,),
                                      );
                                    } else {
                                      return LoadingAnimationWidget.inkDrop(color: Colors.black, size: 40);
                                    }
                                  },
                                )
                            );
                          },
                        );
                      }, text: 'Police Station',
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