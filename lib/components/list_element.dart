import 'package:flutter/material.dart';
import 'package:xpressready/model/accident_model.dart';

class ListElement extends StatefulWidget {
  final Accident data;

  const ListElement({Key? key, required this.data}) : super(key: key);

  @override
  ListElementState createState() => ListElementState();
}

class ListElementState extends State<ListElement> {

  @override
  Widget build(BuildContext context) {

    double baseWidth = MediaQuery.of(context).size.width;

    return Material(
      color: Colors.transparent,
      child: Container(
        width: baseWidth*0.90,
        padding: const EdgeInsets.all(15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black12),
          borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.data.expressWay} - ${widget.data.accidentDate} : ${widget.data.accidentTime}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFAC5757)),
            ),
            Row(
              children: [
                const Text("\u2022", style: TextStyle(fontSize: 30, color: Color(0xFFAC5757)),), //bullet text
                const SizedBox(width: 10,), //space between bullet and text
                Expanded(
                  child: Text(
                    widget.data.cause,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFAC5757)),
                  ),
                )
              ]
            ),
          ],
        ),
      ),
    );
  }

}