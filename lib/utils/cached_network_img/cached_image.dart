import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:giro_driver_app/theme/app_widgets/single_shimmer.dart';

class CachedImage extends StatelessWidget {
  const CachedImage({
    Key? key,
    required this.imageUrl,
    this.placeholder,
    this.errorWidget,
    this.height,
    this.width,
    this.fit,
  }) : super(key: key);

  final String imageUrl;
  final Widget? placeholder;
  final Widget? errorWidget;
  final double? height;
  final double? width;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      // cacheManager: customCacheManger,
      key: UniqueKey(),
      imageUrl: imageUrl,
      width: width, 
      height: height, 
      fit: fit??BoxFit.cover,
      placeholder: (context, url) => placeholder ?? const SingleShimmer(), 
      errorWidget: (context, url, error) =>
      
          errorWidget ?? Image.asset('assets/png/img_placeholder.png'),  
    );
  }
}