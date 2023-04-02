import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xpressready/model/place_model.dart';

class NearestServiceList extends StatelessWidget {
  final List<Place> places;

  const NearestServiceList({super.key, required this.places});

  Future<void> _launchMap(String googleMapsLocationUrl) async {
    final Uri url = Uri.parse(Uri.encodeFull(googleMapsLocationUrl));

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          shrinkWrap: true,
          itemCount: places.length,
          itemBuilder: (BuildContext context, int index) {
            return InkWell(
              onTap: () async {
                _launchMap("https://www.google.com/maps/search/?api=1&query=${places[index].latitude},${places[index].longitude}&query_place_id=${places[index].place_id}");
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.black)
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, size: 30,),
                    Flexible(
                      child: Text(
                        places[index].name,
                        overflow: TextOverflow.fade,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w400, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      )
    );
  }
}