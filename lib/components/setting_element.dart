import 'package:flutter/material.dart';

class MySettingElement extends StatelessWidget {
  final Function()? onTap;
  final String header;
  final String? subHeader;
  final Icon icon;

  const MySettingElement({super.key, this.onTap, required this.header, this.subHeader, required this.icon});

  @override
  Widget build(BuildContext context) {

    double baseWidth = MediaQuery.of(context).size.width;

    return InkWell(
      onTap: onTap,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: baseWidth*0.9
        ),
        padding: const EdgeInsets.only(top: 15, bottom: 15),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),

                if (subHeader != null)
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                      subHeader!,
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                      ),
                    ),
                  )
              ],
            ),

            const Spacer(),

            const Icon(
              Icons.arrow_forward_ios,
              size: 40,
            )
          ],
        )
      ),
    );
  }
}