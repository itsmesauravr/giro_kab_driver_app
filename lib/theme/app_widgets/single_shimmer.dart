import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SingleShimmer extends StatelessWidget {
  final double height;
  final double? width;
  final double radius;
  const SingleShimmer({
    this.radius = 16,
    this.width = double.infinity, 
    this.height = double.infinity ,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
          height: height,
      child: Shimmer.fromColors(
        baseColor: const Color.fromARGB(248, 89, 88, 88),
                  highlightColor: const Color.fromARGB(255, 162, 161, 161),
                  enabled: true, 
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            color: const Color.fromARGB(255, 158, 157, 157),
          ),
         
        ),
      ),
    );
  }
}