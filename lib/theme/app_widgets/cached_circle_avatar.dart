import 'package:flutter/material.dart';
import 'package:giro_driver_app/utils/cached_network_img/cached_image.dart';

class CachedAvatar extends StatelessWidget {
  const CachedAvatar({
    Key? key,
    required this.imageUrl,
    required this.height,
    required this.width,
    this.onTap,
  }) : super(key: key);

  final String imageUrl;
  final double height;
  final double width;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: CachedImage(
          errorWidget: Image.asset('assets/img/avatar.jpg'),
          imageUrl: imageUrl,
          height: height,
          width: width,
        ),
      ),
    );
  }
}