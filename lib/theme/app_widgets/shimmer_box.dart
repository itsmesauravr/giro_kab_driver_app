import 'package:flutter/material.dart';

class ShimmerBox extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  const ShimmerBox({
    this.radius = 16,
    this.width,
    this.height = 150,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding( 
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: const Color.fromARGB(255, 158, 157, 157),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      ),
    );
  }
}