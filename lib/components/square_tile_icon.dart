import 'package:flutter/material.dart';

class SquareTile extends StatelessWidget {
  final Icon? icon;
  final String? imagePath;

  const SquareTile({
    super.key,
    this.imagePath,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: imagePath != null?
        Image.asset(
          imagePath!,
          height: 40,
        ):
          icon
    );
  }
}